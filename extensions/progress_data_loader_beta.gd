extends "res://singletons/progress_data_loader_beta.gd"

const MOD_LOG := "[GMO_FIX] "

func deserialize_run_state(state: Dictionary) -> Dictionary:
    print(MOD_LOG + "deserialize_run_state start")
    var injected := _inject_missing_templates(state)
    if injected.size() > 0:
        print(MOD_LOG + "Injected %d ItemCharacterData templates: %s" % [injected.size(), str(injected)])
    else:
        print(MOD_LOG + "No templates needed to inject")

    var result =.deserialize_run_state(state)

    print(MOD_LOG + "Original deserialize complete, now cleaning up")
    _remove_injected_templates(injected)
    print(MOD_LOG + "deserialize_run_state finished")
    return result

func _inject_missing_templates(state: Dictionary) -> Array:
    var injected := []
    if not state.has("players_data"):
        print(MOD_LOG + "state has no players_data, skip injection")
        return injected

    for i in range(state["players_data"].size()):
        var player_data = state["players_data"][i]
        if not player_data.has("items"):
            print(MOD_LOG + "player %d has no items, skip" % i)
            continue

        var items = player_data["items"]
        print(MOD_LOG + "player %d has %d items in state" % [i, items.size()])
        for item in items:
            var item_id = item.get("my_id", "")
            if item_id.begins_with("item_character_"):
                print(MOD_LOG + "Found character item: %s" % item_id)
                if not ItemService.get_element_safe(ItemService.items, item_id):
                    var char_id = item_id.trim_prefix("item_")
                    var char_template = ItemService.get_element_safe(ItemService.characters, char_id)
                    if char_template:
                        print(MOD_LOG + "Creating template from character: %s" % char_id)
                        var char_item = ItemCharacterData.new()
                        char_item.clone(char_template)
                        char_item.my_id = item_id
                        char_item.my_id_hash = Keys.generate_hash(item_id)
                        if char_item.has_method("_generate_hashes"):
                            char_item._generate_hashes()
                        ItemService.items.push_back(char_item)
                        injected.append(item_id)
                        print(MOD_LOG + "Injected template for %s" % item_id)
                    else:
                        print(MOD_LOG + "WARNING: character template not found for %s" % char_id)
                else:
                    print(MOD_LOG + "Template already exists for %s, skip" % item_id)
    return injected

func _remove_injected_templates(ids: Array) -> void:
    if ids.empty():
        return
    print(MOD_LOG + "Removing injected templates: %s" % str(ids))
    var removed_count := 0
    for i in range(ItemService.items.size() - 1, -1, -1):
        var it = ItemService.items[i]
        if it is ItemCharacterData and it.my_id in ids:
            ItemService.items.remove(i)
            removed_count += 1
    print(MOD_LOG + "Removed %d injected templates" % removed_count)

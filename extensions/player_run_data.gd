extends "res://singletons/player_run_data.gd"

var optimize_selected_items: Array = []
var optimize_selected_other_characters: Array = []

# =========================== Extension =========================== #
func duplicate(): # ! Avoid class problem
    var copy =.duplicate()
    copy.optimize_selected_items = optimize_selected_items.duplicate()

    return copy

func serialize() -> Dictionary:
    var serialized: Dictionary =.serialize()

    var serialized_optimize_selected_items: Array = []
    var serialized_optimize_selected_items_cache: Dictionary = {}
    for optimize_selected_item in optimize_selected_items:
        if optimize_selected_item.is_cursed:
            serialized_optimize_selected_items.append(optimize_selected_item.serialize())
        else:
            var serialized_optimize_selected_item = serialized_optimize_selected_items_cache.get(optimize_selected_item.my_id)
            if !serialized_optimize_selected_item:
                serialized_optimize_selected_item = optimize_selected_item.serialize()
                serialized_optimize_selected_items_cache[optimize_selected_item.my_id] = serialized_optimize_selected_item

            serialized_optimize_selected_items.append(serialized_optimize_selected_item)
    
    var serialized_optimize_selected_other_characters: Array = []
    var serialized_optimize_selected_other_characters_cache: Dictionary = {}
    for optimize_selected_other_character in optimize_selected_other_characters:
        if optimize_selected_other_character.is_cursed:
            serialized_optimize_selected_other_characters.append(optimize_selected_other_character.serialize())
        else:
            var serialized_optimize_selected_other_character = serialized_optimize_selected_other_characters_cache.get(optimize_selected_other_character.my_id)
            if !serialized_optimize_selected_other_character:
                serialized_optimize_selected_other_character = optimize_selected_other_character.serialize()
                serialized_optimize_selected_other_characters_cache[optimize_selected_other_character.my_id] = serialized_optimize_selected_other_character

            serialized_optimize_selected_other_characters.append(serialized_optimize_selected_other_character)

    serialized.optimize_selected_items = serialized_optimize_selected_items
    serialized.optimize_selected_other_characters = serialized_optimize_selected_other_characters

    return serialized

func deserialize(data: Dictionary): # ! Avoid class problem
    .deserialize(data)

    for optimize_selected_item in data.optimize_selected_items:
        if optimize_selected_item is String: continue

        var optimize_selected_item_data: ItemData = ItemService.get_element_safe(ItemService.items, optimize_selected_item.my_id)
        if optimize_selected_item_data:
            optimize_selected_item_data = optimize_selected_item_data.duplicate()
            optimize_selected_item_data.deserialize_and_merge(optimize_selected_item)
            optimize_selected_items.append(optimize_selected_item_data)

    for optimize_selected_other_character in data.optimize_selected_other_characters:
        if optimize_selected_other_character is String: continue

        var optimize_selected_other_character_data: ItemCharacterData = ItemService.get_element_safe(ItemService.gmo_characters, optimize_selected_other_character.my_id)
        if optimize_selected_other_character_data:
            optimize_selected_other_character_data = optimize_selected_other_character_data.duplicate()
            optimize_selected_other_character_data.deserialize_and_merge(optimize_selected_other_character)
            optimize_selected_other_characters.append(optimize_selected_other_character_data)

    return self

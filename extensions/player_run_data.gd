extends "res://singletons/player_run_data.gd"

var selected_items_characters: Array = []

# =========================== Extension =========================== #
func duplicate(): # ! Avoid class problem
    var copy =.duplicate()
    copy.selected_items_characters = selected_items_characters.duplicate()

    return copy

func serialize() -> Dictionary:
    var serialized: Dictionary =.serialize()

    var serialized_items_characters: Array = []
    var serialize_cache: Dictionary = {}
    for item_character in selected_items_characters:
        if item_character.is_cursed:
            serialized_items_characters.append(item_character.serialize())
        else:
            var serialized_item: Dictionary = serialize_cache.get(item_character.my_id)
            if !serialized_item:
                serialized_item = item_character.serialize()
                serialize_cache[item_character.my_id] = serialized_item

            serialized_items_characters.append(serialized_item)

    serialized.selected_items_characters = serialized_items_characters

    return serialized

func deserialize(data: Dictionary): # ! Avoid class problem
    .deserialize(data)

    for item_character in data.selected_items_characters:
        if item_character is String: continue

        var item_character_data_data: ItemData = ItemService.get_element_safe(ItemService.items, item_character.my_id)
        if !item_character_data_data:
            item_character_data_data = item_character_data_data.duplicate()
            item_character_data_data.deserialize_and_merge(item_character)
            selected_items_characters.append(item_character_data_data)

    return self

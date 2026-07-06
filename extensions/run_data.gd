extends "res://singletons/run_data.gd"

# =========================== Extension =========================== #
func add_starting_items_and_weapons() -> void:
    _optimize_add_starting_items_characters()
    .add_starting_items_and_weapons()

# =========================== Custom =========================== #
func _optimize_add_starting_items_characters() -> void:
    var selected_items_characters: Array = []
    for player_data in players_data:
        selected_items_characters.append(player_data.selected_items_characters)

    for i in range(selected_items_characters.size()):
        var items_characters: Array = selected_items_characters[i]
        for selected_item_character in items_characters:
            add_item(selected_item_character, i)

# =========================== Method =========================== #
func op_add_starting_item_character(item_character: ItemData, player_index: int) -> void:
    var selected_items_characters: Array = players_data[player_index].selected_items_characters
    selected_items_characters.append(item_character)

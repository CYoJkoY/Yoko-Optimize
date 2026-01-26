extends "res://ui/menus/run/weapon_selection.gd"

# =========================== Extention =========================== #
func _get_unlocked_elements(player_index: int)->Array:
    var unlocked: Array = ._get_unlocked_elements(player_index)
    unlocked = _yztato_starting_weapons_unlock(unlocked)

    return unlocked

func _get_all_possible_elements(player_index: int)->Array:
    var possible_weapons: Array = ._get_all_possible_elements(player_index)
    possible_weapons = _yztato_starting_weapons_possible(possible_weapons)

    return possible_weapons

# =========================== Custom =========================== #
func _yztato_starting_weapons_unlock(unlocked: Array) -> Array:
    if ProgressData.settings.yztato_starting_weapons:
        unlocked = []
        for weapon in ItemService.weapons:
            unlocked.push_back(weapon.my_id_hash)
        for item in ItemService.items:
            unlocked.push_back(item.my_id_hash)

    return unlocked

func _yztato_starting_weapons_possible(possible_weapons: Array) -> Array:
    if ProgressData.settings.yztato_starting_weapons:
        possible_weapons = []
        possible_weapons.append_array(ItemService.weapons)
        possible_weapons.append_array(ItemService.items)

    return possible_weapons

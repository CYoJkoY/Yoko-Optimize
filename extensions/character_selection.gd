extends "res://ui/menus/run/character_selection.gd"

const FONT_RESOURCE = preload("res://resources/fonts/actual/base/font_40_outline_thick.tres")
var _player_gmo_num: int = ProgressData.settings.yztato_gmo_num

# =========================== Extension =========================== #
func _get_unlocked_elements(player_index: int) -> Array:
    var unlocked: Array = ._get_unlocked_elements(player_index)
    unlocked = _yztato_unlock_all_chars(unlocked, player_index)
    
    return unlocked

# =========================== Custom =========================== #
func _yztato_unlock_all_chars(unlocked: Array, player_index: int) -> Array:
    if ProgressData.settings.yztato_unlock_all_chars:
        var all_unlocked: = []
        for element in _get_all_possible_elements(player_index):
            all_unlocked.append(element.my_id_hash)
        return all_unlocked

    return unlocked

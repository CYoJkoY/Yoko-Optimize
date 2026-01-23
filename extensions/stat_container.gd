extends "res://ui/menus/shop/stat_container.gd"

# =========================== Extention =========================== #
func update_player_stat(player_index: int)->void :
    .update_player_stat(player_index)
    if ProgressData.settings.yztato_number_optimize:
        _yztato_update_player_stat(player_index)

# =========================== Custom =========================== #
func _yztato_update_player_stat(player_index: int)->void :
    var stat_value = Utils.get_stat(key_hash, player_index)
    var value_text = ProgressData.Optimize.Methods.format_number(stat_value as int)

    var dodge_cap = RunData.get_player_effect(Keys.dodge_cap_hash, player_index)
    var hp_cap = RunData.get_player_effect(Keys.hp_cap_hash, player_index)
    var speed_cap = RunData.get_player_effect(Keys.speed_cap_hash, player_index)
    var crit_chance_cap = RunData.get_player_effect(Keys.crit_chance_cap_hash, player_index)

    if key_hash == Keys.stat_dodge_hash and (dodge_cap < stat_value or dodge_cap < 60):
        value_text += " | " + ProgressData.Optimize.Methods.format_number(dodge_cap as int)
    elif key_hash == Keys.stat_max_hp_hash and hp_cap < Utils.LARGE_NUMBER:
        value_text += " | " + ProgressData.Optimize.Methods.format_number(hp_cap as int)
    elif key_hash == Keys.stat_speed_hash and speed_cap < Utils.LARGE_NUMBER:
        value_text += " | " + ProgressData.Optimize.Methods.format_number(speed_cap as int)
    elif key_hash == Keys.stat_crit_chance_hash and crit_chance_cap < Utils.LARGE_NUMBER:
        value_text += " | " + ProgressData.Optimize.Methods.format_number(crit_chance_cap as int)

    _value.text = value_text

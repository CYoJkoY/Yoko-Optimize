extends "res://ui/menus/shop/reroll_button.gd"

# =========================== Extension =========================== #
func init(value: int, player_index: int) -> void:
    .init(value, player_index)
    if ProgressData.settings.yztato_number_optimize:
        _yztato_init(value, player_index)

# =========================== Custom =========================== #
func _yztato_init(value: int, player_index: int) -> void:
    set_value(value, RunData.get_player_gold(player_index))
    var txt: String = (tr("REROLL") + " - " + Utils.ncl_format_number(value)).to_upper()
    if RunData.is_coop_run:
        set_text(txt)
    else:
        set_text("      " + txt)

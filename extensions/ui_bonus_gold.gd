extends "res://ui/hud/ui_bonus_gold.gd"

# =========================== Extention =========================== #
func _ready()->void :
    if ProgressData.settings.yztato_number_optimize:
        _gold_label.text = ProgressData.Optimize.Methods.format_number(RunData.bonus_gold)


func update_value(new_value: int)->void :
    .update_value(new_value)
    if ProgressData.settings.yztato_number_optimize:
        _gold_label.text = ProgressData.Optimize.Methods.format_number(new_value)

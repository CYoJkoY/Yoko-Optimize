extends "res://ui/hud/ui_bonus_gold.gd"

# =========================== Extention =========================== #
func _ready()->void :
	if ProgressData.settings.yztato_number_optimize:
		_gold_label.text = ProgressData.Optimize.Methods.format_number(RunData.bonus_gold)


func update_value(new_value: int)->void :
	if ProgressData.settings.yztato_number_optimize:
		_gold_label.text = ProgressData.Optimize.Methods.format_number(new_value)
	else:
		.update_value(new_value)
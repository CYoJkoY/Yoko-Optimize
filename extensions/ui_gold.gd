extends "res://ui/hud/ui_gold.gd"

# =========================== Extention =========================== #
func update_value(value: int)->void :
	.update_value(value)
	if ProgressData.settings.yztato_number_optimize:
		gold_label.text = ProgressData.Optimize.Methods.format_number(value)

extends "res://ui/menus/run/gold_label.gd"

func update_value(value: int)->void :
	.update_value(value)
	if ProgressData.settings.yztato_number_optimize:
		text = ProgressData.Optimize.Methods.format_number(value)

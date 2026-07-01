extends "res://ui/menus/run/gold_label.gd"

func update_value(value: int) -> void:
    .update_value(value)
    if ProgressData.optimize_settings.optimize_number_optimize:
        text = Utils.opt_format_number(value)

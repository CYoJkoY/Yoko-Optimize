extends "res://ui/menus/shop/button_with_icon.gd"

# =========================== Extension =========================== #
func set_value(value: int, currency: int)->void :
    .set_value(value, currency)
    if ProgressData.settings.yztato_number_optimize:
        _label.text = ProgressData.Optimize.Methods.format_number(value)

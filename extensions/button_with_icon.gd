extends "res://ui/menus/shop/button_with_icon.gd"

# =========================== Extention =========================== #
func set_value(value: int, currency: int)->void :
	if ProgressData.settings.yztato_number_optimize:
		_value = value
		_label.text = ProgressData.Optimize.Methods.format_number(value)
		set_color_from_currency(currency)
	else:
		.set_value(value, currency)
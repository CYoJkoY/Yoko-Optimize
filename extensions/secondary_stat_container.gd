extends "res://ui/menus/shop/secondary_stat_container.gd"

onready var _icon:TextureRect = TextureRect.new()
onready var _HBoxContainer = $HBoxContainer

# =========================== Extention =========================== #
func _ready() -> void:
	_icon.expand = true
	_icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT
	_icon.rect_min_size = Vector2(30, 30)
	_HBoxContainer.add_child(_icon)
	_HBoxContainer.move_child(_icon, 0)

func update_player_stat(player_index: int)->void :
	_icon.texture = ItemService.get_stat_small_icon(key.to_lower())

	if ProgressData.settings.yztato_number_optimize:
		_yztato_update_player_stat(player_index)
	else:
		.update_player_stat(player_index)

# =========================== Custom =========================== #
func _yztato_update_player_stat(player_index: int)->void :
	var stat_value = Utils.get_stat(key.to_lower(), player_index)

	
	if key.to_lower() == "structure_attack_speed":
		stat_value = WeaponService.get_structure_attack_speed(player_index)

	var value_text = ProgressData.Optimize.Methods.format_number(stat_value as int)

	_label.text = custom_text_key if custom_text_key != "" else key
	_value.text = value_text

	if (stat_value > 0 and not reverse) or (stat_value < 0 and reverse):
		_label.modulate = ProgressData.settings.color_positive
		_value.modulate = ProgressData.settings.color_positive
	elif (stat_value < 0 and not reverse) or (stat_value > 0 and reverse):
		_label.modulate = ProgressData.settings.color_negative
		_value.modulate = ProgressData.settings.color_negative
	else :
		_label.modulate = Color.white
		_value.modulate = Color.white
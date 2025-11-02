extends "res://entities/units/enemies/enemy.gd"

# =========================== Extension =========================== #
func _ready():
	_yztato_set_enemy_transparency(ProgressData.settings.yztato_set_enemy_transparency)

func respawn() -> void:
	.respawn()
	_yztato_set_enemy_transparency(ProgressData.settings.yztato_set_enemy_transparency)

# =========================== Custom =========================== #
func _yztato_set_enemy_transparency(alpha_value: float) -> void:
	var clamped_alpha = clamp(alpha_value, 0.0, 1.0)
	modulate.a = clamped_alpha

extends "res://entities/units/enemies/enemy.gd"

# =========================== Extension =========================== #
func _ready():
    _optimize_set_enemy_transparency(ProgressData.optimize_settings.optimize_set_enemy_transparency)

func respawn() -> void:
    .respawn()
    _optimize_set_enemy_transparency(ProgressData.optimize_settings.optimize_set_enemy_transparency)

# =========================== Custom =========================== #
func _optimize_set_enemy_transparency(alpha_value: float) -> void:
    var clamped_alpha = clamp(alpha_value, 0.0, 1.0)
    modulate.a = clamped_alpha

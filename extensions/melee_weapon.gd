extends "res://weapons/melee/melee_weapon.gd"

# =========================== Extention =========================== #
func _ready():
    _yztato_set_weapon_transparency(ProgressData.settings.yztato_set_weapon_transparency)

# =========================== Custom =========================== #
func _yztato_set_weapon_transparency(alpha_value: float) -> void:
    var clamped_alpha = clamp(alpha_value, 0.0, 1.0)
    modulate.a = clamped_alpha

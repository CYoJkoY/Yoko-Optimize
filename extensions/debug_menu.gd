extends "res://ui/menus/debug/debug_menu.gd"

var mods_enemies_directories = [
    "res://mods-unpacked/Yoko-YzTato/content/entities/enemies",
    "res://mods-unpacked/Yoko-Fantasy/content/entities/enemies",
]

# =========================== Extension =========================== #
func _set_menu() -> void:
    ._set_menu()
    enemies_directories.append_array(mods_enemies_directories)

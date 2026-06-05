extends "res://ui/menus/pages/main_menu.gd"

signal optimize_set_button_pressed

onready var buttons_right = $MarginContainer/VBoxContainer/HBoxContainer/ButtonsRight

# =========================== Extension =========================== #
func _ready() -> void:
    # After init and avoid .init()
    # Equals to init() + .init()
    _optimize_set_button_ready()

# =========================== Custom =========================== #
func _optimize_set_button_ready() -> void:
    if buttons_right.has_node("OptimizeSetButton"): return

    var optimize_set_button = MyMenuButton.new()
    optimize_set_button.name = "OptimizeSetButton"
    optimize_set_button.text = "MENU_OPTIMIZE_SET"
    optimize_set_button.size_flags_horizontal = Control.SIZE_SHRINK_END
    
    buttons_right.add_child(optimize_set_button)
    var mods_button_index: int = mods_button.get_index()
    buttons_right.move_child(optimize_set_button, mods_button_index)

    optimize_set_button.connect("pressed", self , "_on_OptimizeSetButton_pressed")
    
    optimize_set_button.focus_neighbour_left = start_button.get_path()
    optimize_set_button.focus_neighbour_right = start_button.get_path()
    optimize_set_button.focus_neighbour_top = credits_button.get_path()
    mods_button.focus_neighbour_top = optimize_set_button.get_path()

func _on_OptimizeSetButton_pressed() -> void:
    emit_signal("optimize_set_button_pressed")

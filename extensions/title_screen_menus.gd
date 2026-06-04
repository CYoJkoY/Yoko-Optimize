extends "res://ui/menus/title_screen/title_screen_menus.gd"

# =========================== Extension =========================== #
func _ready():
    _optimize_set_options()

# =========================== Custom =========================== #
func _optimize_set_options() -> void:
    var _optimize_set_options = load("res://mods-unpacked/Yoko-Optimize/content/scenes/set_scene.tscn").instance()
    add_child(_optimize_set_options)
    _optimize_set_options.name = "MenuoptimizeSetOptions"
    _optimize_set_options.visible = false

    _optimize_set_options.connect("back_button_pressed", self , "on_options_optimize_set_back_button_pressed", [_optimize_set_options])
    _main_menu.connect("optimize_set_button_pressed", self , "on_options_optimize_set_button_pressed", [_optimize_set_options])

func on_options_optimize_set_back_button_pressed(_optimize_set_options) -> void:
    switch(_optimize_set_options, _main_menu)

func on_options_optimize_set_button_pressed(_optimize_set_options) -> void:
    switch(_main_menu, _optimize_set_options)

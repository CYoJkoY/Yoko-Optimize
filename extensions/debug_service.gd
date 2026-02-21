extends "res://singletons/debug_service.gd"

# =========================== Extension =========================== #
func _input(event):
    ._input(event)

    if OS.is_debug_build() or !event.is_action_pressed("open_debug_menu"): return
    
    if is_instance_valid(current_debug_menu): return

    current_debug_menu = debug_menu.instance()
    if get_tree().current_scene is Main: get_tree().current_scene.get_node("UI").add_child(current_debug_menu)
    else: get_tree().current_scene.add_child(current_debug_menu)

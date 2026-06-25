extends VBoxContainer

signal palette_name_changed(palette_id, new_name)
signal palette_active_toggled(palette_id, active)
signal palette_deleted(palette_id)
signal color_changed(palette_id, color_index, new_color)
signal color_removed(palette_id, color_index)
signal hold_started(color_id)
signal hold_ended(color_id)
signal hold_completed(color_id)

var palette_id: String = ""
var color_grid: HFlowContainer = null

func setup(p_id: String, initial_name: String, is_active: bool) -> void:
    palette_id = p_id
    var top_row: HBoxContainer = get_node("TopRow")
    var cb: CheckButton = top_row.get_node("ActiveCheck")
    var name_edit: LineEdit = top_row.get_node("NameEdit")
    var del_btn: Button = top_row.get_node("DeletePaletteBtn")
    color_grid = get_node("ColorGrid")
    
    cb.pressed = is_active
    name_edit.text = initial_name
    
    cb.connect("toggled", self, "_on_active_toggled")
    name_edit.connect("text_entered", self, "_on_name_changed")
    name_edit.connect("focus_exited", self, "_on_name_focus_exited", [name_edit])
    del_btn.connect("pressed", self, "_on_delete_pressed")

func _on_active_toggled(pressed) -> void:
    emit_signal("palette_active_toggled", palette_id, pressed)

func _on_name_changed(new_text) -> void:
    emit_signal("palette_name_changed", palette_id, new_text)

func _on_name_focus_exited(name_edit) -> void:
    emit_signal("palette_name_changed", palette_id, name_edit.text)

func _on_delete_pressed() -> void:
    emit_signal("palette_deleted", palette_id)

func add_color_item(color_item_node) -> void:
    color_grid.add_child(color_item_node)
    color_item_node.connect("color_changed", self, "_on_color_changed")
    color_item_node.connect("color_removed", self, "_on_color_removed")
    color_item_node.connect("hold_started", self, "_on_hold_started")
    color_item_node.connect("hold_ended", self, "_on_hold_ended")
    color_item_node.connect("hold_completed", self, "_on_hold_completed")

func _on_color_changed(p_id, c_idx, new_color) -> void:
    emit_signal("color_changed", p_id, c_idx, new_color)

func _on_color_removed(p_id, c_idx) -> void:
    emit_signal("color_removed", p_id, c_idx)

func _on_hold_started(color_id) -> void:
    emit_signal("hold_started", color_id)

func _on_hold_ended(color_id) -> void:
    emit_signal("hold_ended", color_id)

func _on_hold_completed(color_id) -> void:
    emit_signal("hold_completed", color_id)

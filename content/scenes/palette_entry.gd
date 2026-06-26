extends VBoxContainer

signal palette_name_changed(palette_id, new_name)
signal palette_active_toggled(palette_id, active)
signal palette_deleted(palette_id)
signal color_changed(palette_id, color_index, new_color)
signal request_delete_color(palette_id, color_index)

var palette_id: String = ""
var _last_name: String = ""
var color_grid: HFlowContainer = null

func setup(p_id: String, initial_name: String, is_active: bool) -> void:
    palette_id = p_id
    _last_name = initial_name

    var top_row: HBoxContainer = get_node("TopRow")
    var cb: CheckButton = top_row.get_node("ActiveCheck")
    var name_edit: LineEdit = top_row.get_node("NameEdit")
    var del_btn: Button = top_row.get_node("DeletePaletteBtn")
    color_grid = get_node("ColorGrid")
    
    cb.pressed = is_active
    name_edit.text = initial_name

    if cb.is_connected("toggled", self, "_on_active_toggled"): cb.disconnect("toggled", self, "_on_active_toggled")
    if name_edit.is_connected("focus_exited", self, "_on_name_focus_exited"): name_edit.disconnect("focus_exited", self, "_on_name_focus_exited")
    if del_btn.is_connected("pressed", self, "_on_delete_pressed"): del_btn.disconnect("pressed", self, "_on_delete_pressed")

    cb.connect("toggled", self, "_on_active_toggled")
    name_edit.connect("focus_exited", self, "_on_name_focus_exited", [name_edit])
    del_btn.connect("pressed", self, "_on_delete_pressed")

func _on_active_toggled(pressed) -> void:
    emit_signal("palette_active_toggled", palette_id, pressed)

func _on_name_focus_exited(name_edit: LineEdit) -> void:
    var new_text: String = name_edit.text
    if new_text != _last_name:
        _last_name = new_text
        emit_signal("palette_name_changed", palette_id, new_text)

func _on_delete_pressed() -> void:
    emit_signal("palette_deleted", palette_id)

func add_color_item(color_item_node: Control) -> void:
    color_grid.add_child(color_item_node)

    if !color_item_node.is_connected("color_changed", self, "_on_color_changed"):
        color_item_node.connect("color_changed", self, "_on_color_changed")
    if !color_item_node.is_connected("request_delete_color", self, "_on_request_delete_color"):
        color_item_node.connect("request_delete_color", self, "_on_request_delete_color")

func _on_color_changed(p_id, c_idx, new_color) -> void:
    emit_signal("color_changed", p_id, c_idx, new_color)

func _on_request_delete_color(p_id, c_idx) -> void:
    emit_signal("request_delete_color", p_id, c_idx)

extends Control

signal color_changed(palette_id, color_index, new_color)
signal color_removed(palette_id, color_index)
signal hold_started(color_id)
signal hold_ended(color_id)

var color_id: String = ""
var palette_id: String = ""
var color_index: int = -1

# =========================== Extension =========================== #
func setup(p_id: String, p_palette_id: String, p_color_index: int, initial_color: Color) -> void:
    color_id = p_id
    palette_id = p_palette_id
    color_index = p_color_index
    set_meta("color_id", p_id)
    var color_btn: ColorPickerButton = get_node("ColorPickerButton")
    color_btn.color = initial_color
    color_btn.connect("color_changed", self, "_on_color_changed")
    var hold_btn: Button = get_node("HoldButton")
    hold_btn.connect("button_down", self, "_on_hold_button_down")
    hold_btn.connect("button_up", self, "_on_hold_button_up")

func _on_color_changed(new_color) -> void:
    emit_signal("color_changed", palette_id, color_index, new_color)

func _on_hold_button_down() -> void:
    emit_signal("hold_started", color_id)

func _on_hold_button_up() -> void:
    emit_signal("hold_ended", color_id)

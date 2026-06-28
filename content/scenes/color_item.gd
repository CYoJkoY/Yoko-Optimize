extends Control

signal color_changed(palette_id, color_index, new_color)
signal request_delete_color(palette_id, color_index)

const CLICK_THRESHOLD: float = 0.2
const HOLD_DURATION: float = 0.8
const VERY_SMALL_BUTTON_THEME: Theme = preload("res://resources/themes/verysmall_option_button_theme.tres")

var color_id: String = ""
var palette_id: String = ""
var color_index: int = -1
var _initial_color: Color = Color.white

var _press_time: float = 0.0
var _is_holding: bool = false

onready var mask: ColorRect = $HoldMask
onready var picker: ColorPickerButton = $ColorPickerButton

func setup(p_id: String, p_palette_id: String, p_color_index: int, initial_color: Color) -> void:
    color_id = p_id
    palette_id = p_palette_id
    color_index = p_color_index
    _initial_color = initial_color
    set_meta("color_id", p_id)

    if picker:
        picker.color = initial_color

func _ready() -> void:
    picker.color = _initial_color
    picker.connect("color_changed", self, "_on_color_changed")
    $HoldButton.connect("button_down", self, "_on_hold_button_down")
    $HoldButton.connect("button_up", self, "_on_hold_button_up")
    set_process(false)

func _process(_delta: float) -> void:
    if !_is_holding:
        set_process(false)
        return

    var elapsed: float = (OS.get_ticks_msec() / 1000.0) - _press_time
    var progress: float = min(elapsed / HOLD_DURATION, 1.0)

    if mask:
        mask.color.a = progress * 0.6

    if progress >= 1.0:
        _is_holding = false
        set_process(false)
        emit_signal("request_delete_color", palette_id, color_index)

func _on_color_changed(new_color: Color) -> void:
    emit_signal("color_changed", palette_id, color_index, new_color)

func _on_hold_button_down() -> void:
    _press_time = OS.get_ticks_msec() / 1000.0
    _is_holding = true
    set_process(true)

func _on_hold_button_up() -> void:
    if !_is_holding: return

    _is_holding = false
    set_process(false)
    if mask:
        mask.color.a = 0.0

    var elapsed: float = (OS.get_ticks_msec() / 1000.0) - _press_time
    if elapsed < CLICK_THRESHOLD:
        var popup: PopupPanel = picker.get_popup()
        if popup:
            popup.popup_centered(Vector2(400, 300))
            var color_picker: ColorPicker = popup.get_child(0)
            color_picker.theme = VERY_SMALL_BUTTON_THEME

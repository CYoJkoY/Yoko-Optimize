# =========================== Extension =========================== #
extends WindowDialog

signal palette_changed

const ADD_ICON: Texture = preload("res://mods-unpacked/Yoko-Optimize/content/icons/add_icon.webp")
const PALETTE_ENTRY: PackedScene = preload("res://mods-unpacked/Yoko-Optimize/content/scenes/palette_entry.tscn")
const COLOR_ITEM: PackedScene = preload("res://mods-unpacked/Yoko-Optimize/content/scenes/color_item.tscn")
const SPECIAL_BUTTON_THEME: Resource = preload("res://resources/themes/special_button_theme.tres")
const HOLD_DURATION: float = 0.8

onready var palette_list: VBoxContainer = $"%PaletteList"
onready var add_palette_btn: Button = $"%AddPaletteBtn"
onready var preview_container: HFlowContainer = $"%PreviewContainer"

var hold_data: Dictionary = {}
var _focused_color_id: String = ""

# =========================== Extension =========================== #
func _ready() -> void:
    refresh()
    set_process(true)

func _process(delta) -> void:
    for key in hold_data.keys():
        var data: Dictionary = hold_data[key]
        if !data["holding"]: continue
        data["timer"] += delta
        data["progress"] = min(data["timer"] / HOLD_DURATION, 1.0)
        var color_item: Control = _get_color_item(key)
        if color_item:
            var mask: ColorRect = color_item.get_node_or_null("HoldMask")
            if mask: mask.color.a = data["progress"] * 0.6
        if data["progress"] >= 1.0:
            var parts: PoolStringArray = key.split("_")
            if parts.size() >= 2:
                var p_id: String = parts[0]
                var c_idx: int = int(parts[1])
                _on_remove_color(p_id, c_idx)
            data["holding"] = false
            data["progress"] = 0.0
            data["timer"] = 0.0
            if color_item:
                var mask: ColorRect = color_item.get_node_or_null("HoldMask")
                if mask: mask.color.a = 0.0

# =========================== Custom =========================== #
func refresh() -> void:
    for child in palette_list.get_children(): child.queue_free()
    hold_data.clear()

    var palettes: Dictionary = ProgressData.op_get_palettes()
    var active_ids: Array = ProgressData.op_get_active_palette_ids()

    for id in palettes.keys():
        var data: Dictionary = palettes[id]
        var entry: Control = PALETTE_ENTRY.instance()
        entry.setup(id, data["name"], active_ids.has(id))
        entry.set_meta("palette_id", id)
        entry.connect("palette_active_toggled", self, "_on_active_toggled")
        entry.connect("palette_name_changed", self, "_on_name_changed")
        entry.connect("palette_deleted", self, "_on_delete_palette")
        entry.connect("color_changed", self, "_on_color_changed")
        entry.connect("color_removed", self, "_on_remove_color")
        entry.connect("hold_started", self, "_on_hold_started")
        entry.connect("hold_ended", self, "_on_hold_ended")

        for color_index in range(data["colors"].size()):
            var color_str: String = data["colors"][color_index]
            var color_id: String = "%s_%d" % [id, color_index]
            var color_item: Control = COLOR_ITEM.instance()
            color_item.setup(color_id, id, color_index, Color(color_str))
            entry.add_color_item(color_item)

        var add_color_btn: Button = Button.new()
        add_color_btn.theme = SPECIAL_BUTTON_THEME
        add_color_btn.icon = ADD_ICON
        add_color_btn.expand_icon = false
        add_color_btn.rect_min_size = Vector2(45, 45)
        add_color_btn.connect("pressed", self, "_on_add_color", [id])
        entry.get_node("ColorGrid").add_child(add_color_btn)

        palette_list.add_child(entry)

    _update_preview()

func _update_preview() -> void:
    for child in preview_container.get_children(): child.queue_free()
    var colors: Array = ProgressData.op_get_runtime_colors()
    if colors.empty():
        var label: Label = Label.new()
        label.text = "No active colors"
        label.align = Label.ALIGN_CENTER
        preview_container.add_child(label)
    else:
        for color_str in colors:
            var rect: ColorRect = ColorRect.new()
            rect.color = Color(color_str)
            rect.rect_min_size = Vector2(40, 40)
            rect.rect_size = Vector2(40, 40)
            preview_container.add_child(rect)

func _get_palette_entry(palette_id: String) -> Control:
    for child in palette_list.get_children():
        if !child.has_meta("palette_id") or child.get_meta("palette_id") != palette_id: continue

        return child

    return null

func _rebuild_entry_colors(entry, palette_id: String, colors: Array) -> void:
    var grid: HFlowContainer = entry.get_node("ColorGrid")
    var to_remove: Array = []
    for child in grid.get_children():
        if !(child is Control) or !child.has_meta("color_id"): continue

        to_remove.append(child)

    for child in to_remove:
        grid.remove_child(child)
        child.queue_free()

    for color_index in range(colors.size()):
        var color_str: String = colors[color_index]
        var color_id: String = "%s_%d" % [palette_id, color_index]
        var color_item: Control = COLOR_ITEM.instance()
        color_item.setup(color_id, palette_id, color_index, Color(color_str))
        entry.add_color_item(color_item)

    var add_btn: Button = grid.get_child(grid.get_child_count() - 1)
    grid.move_child(add_btn, grid.get_child_count() - 1)

    for key in hold_data.keys():
        if !key.begins_with(palette_id + "_"): continue

        hold_data.erase(key)

func _get_color_item(color_id) -> Control:
    for child in palette_list.get_children():
        var grid = child.get_node("ColorGrid")
        if !grid: continue

        for item in grid.get_children():
            if !(item is Control) or !item.has_meta("color_id") or item.get_meta("color_id") != color_id: continue

            return item

    return null

# =========================== Method =========================== #
func _on_active_toggled(palette_id, pressed) -> void:
    var active: Array = ProgressData.op_get_active_palette_ids()
    if pressed: if !active.has(palette_id): active.append(palette_id)
    else: active.erase(palette_id)
    ProgressData.op_set_active_palette_ids(active)
    _update_preview()
    emit_signal("palette_changed")

func _on_name_changed(palette_id, new_name) -> void:
    var palettes: Dictionary = ProgressData.op_get_palettes()
    if !palettes.has(palette_id): return

    var colors: Array = palettes[palette_id]["colors"]
    ProgressData.op_update_palette(palette_id, new_name, colors)
    emit_signal("palette_changed")

func _on_delete_palette(palette_id) -> void:
    ProgressData.op_remove_palette(palette_id)
    refresh()
    emit_signal("palette_changed")

func _on_remove_color(palette_id, color_index) -> void:
    var palettes: Dictionary = ProgressData.op_get_palettes()
    if !palettes.has(palette_id): return

    var colors: Array = palettes[palette_id]["colors"]
    if color_index < 0 or color_index >= colors.size(): return

    colors.remove(color_index)
    ProgressData.op_update_palette(palette_id, palettes[palette_id]["name"], colors)

    var entry: Control = _get_palette_entry(palette_id)
    if entry:
        _rebuild_entry_colors(entry, palette_id, colors)
        _update_preview()
        emit_signal("palette_changed")

func _on_color_changed(palette_id, color_index, new_color) -> void:
    var palettes: Dictionary = ProgressData.op_get_palettes()
    if !palettes.has(palette_id): return
    var colors: Array = palettes[palette_id]["colors"]
    if color_index >= 0 and color_index < colors.size():
        colors[color_index] = new_color.to_html(false)
        ProgressData.op_update_palette(palette_id, palettes[palette_id]["name"], colors)
        _update_preview()
        emit_signal("palette_changed")

func _on_add_color(palette_id) -> void:
    var palettes: Dictionary = ProgressData.op_get_palettes()
    if !palettes.has(palette_id): return

    var colors: Array = palettes[palette_id]["colors"]
    colors.append("#FFFFFF")
    ProgressData.op_update_palette(palette_id, palettes[palette_id]["name"], colors)

    var entry: Control = _get_palette_entry(palette_id)
    if !entry: return

    var color_index: int = colors.size() - 1
    var color_id: String = "%s_%d" % [palette_id, color_index]
    var color_item: Control = COLOR_ITEM.instance()
    color_item.setup(color_id, palette_id, color_index, Color("#FFFFFF"))
    entry.add_color_item(color_item)
    var grid: HFlowContainer = entry.get_node("ColorGrid")
    var add_btn: Button = grid.get_child(grid.get_child_count() - 1)
    grid.move_child(add_btn, grid.get_child_count() - 1)
    _update_preview()
    emit_signal("palette_changed")

func _on_AddPaletteBtn_pressed() -> void:
    var new_id: String = ProgressData.op_add_palette("New Palette", ["#FF0000", "#00FF00"])
    if new_id:
        var active: Array = ProgressData.op_get_active_palette_ids()
        if !active.has(new_id):
            active.append(new_id)
            ProgressData.op_set_active_palette_ids(active)
    refresh()
    emit_signal("palette_changed")

func _on_hold_started(color_id) -> void:
    if !hold_data.has(color_id): hold_data[color_id] = {"holding": false, "timer": 0.0, "progress": 0.0}
    hold_data[color_id]["holding"] = true
    hold_data[color_id]["timer"] = 0.0
    hold_data[color_id]["progress"] = 0.0

func _on_hold_ended(color_id) -> void:
    if !hold_data.has(color_id): return

    hold_data[color_id]["holding"] = false
    hold_data[color_id]["progress"] = 0.0
    hold_data[color_id]["timer"] = 0.0
    var color_item = _get_color_item(color_id)
    if !color_item: return

    var mask = color_item.get_node_or_null("HoldMask")
    if mask: mask.color.a = 0.0

# =========================== Extension =========================== #
extends WindowDialog

signal palette_changed

const ADD_ICON: Texture = preload("res://mods-unpacked/Yoko-Optimize/content/icons/add_icon.webp")
const PALETTE_ENTRY: PackedScene = preload("res://mods-unpacked/Yoko-Optimize/content/scenes/palette_entry.tscn")
const COLOR_ITEM: PackedScene = preload("res://mods-unpacked/Yoko-Optimize/content/scenes/color_item.tscn")
const SPECIAL_BUTTON_THEME: Resource = preload("res://resources/themes/special_button_theme.tres")
const HOLD_DURATION: float = 0.8

onready var palette_list: VBoxContainer = $"%PaletteList"
onready var preview_container: HFlowContainer = $"%PreviewContainer"

var hold_data: Dictionary = {}
var _pending_deletions: Array = []

# =========================== Extension =========================== #
func _ready() -> void:
    refresh()
    set_process(false)

# =========================== Custom =========================== #
func refresh() -> void:
    for child in palette_list.get_children(): child.queue_free()

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
        entry.connect("request_delete_color", self, "_on_remove_color")

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
        add_color_btn.set_meta("is_add_btn", true)
        add_color_btn.connect("pressed", self, "_on_add_color", [id])
        entry.get_node("ColorGrid").add_child(add_color_btn)

        palette_list.add_child(entry)

    _update_preview()

func _update_preview() -> void:
    for child in preview_container.get_children(): child.queue_free()

    var palettes: Dictionary = ProgressData.op_get_palettes()
    var active_ids: Array = ProgressData.op_get_active_palette_ids()
    var colors: Array = []
    for id in active_ids:
        if !palettes.has(id): continue

        for c in palettes[id]["colors"]: colors.append(c)

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
    if !grid: return

    var add_btn: Control = null
    for child in grid.get_children():
        if !child.has_meta("is_add_btn") or !child.get_meta("is_add_btn"): continue

        add_btn = child
        break

    if add_btn == null:
        add_btn = Button.new()
        add_btn.theme = SPECIAL_BUTTON_THEME
        add_btn.icon = ADD_ICON
        add_btn.expand_icon = false
        add_btn.rect_min_size = Vector2(45, 45)
        add_btn.set_meta("is_add_btn", true)
        add_btn.connect("pressed", self, "_on_add_color", [palette_id])
        grid.add_child(add_btn)

    for child in grid.get_children():
        if child == add_btn: continue

        grid.remove_child(child)
        child.queue_free()

    for color_index in range(colors.size()):
        var color_str: String = colors[color_index]
        var color_id: String = "%s_%d" % [palette_id, color_index]
        var color_item: Control = COLOR_ITEM.instance()
        color_item.setup(color_id, palette_id, color_index, Color(color_str))
        entry.add_color_item(color_item)

    grid.move_child(add_btn, grid.get_child_count() - 1)

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
    match [pressed, active.has(palette_id)]:
        [true, false]: active.append(palette_id)
        [false, true]: active.erase(palette_id)

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

    _rebuild_entry_colors(entry, palette_id, colors)
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

extends Control

signal back_button_pressed

onready var scroll_container: ScrollContainer = $"ScrollContainer"
onready var palette_manager: WindowDialog = $"PaletteManager"
onready var back_button: Button = $BackButton
onready var focus_before_created: Control = get_focus_owner()

onready var StartingWeapons: CheckButton = $"%StartingWeapons"
onready var StartingItems: CheckButton = $"%StartingItems"
onready var OptimizePickUp: CheckButton = $"%OptimizePickUp"
onready var CurseStrength: CheckButton = $"%CurseStrength"
onready var NumberOptimize: CheckButton = $"%NumberOptimize"
onready var Gmo: CheckButton = $"%GMO"

onready var SetWeaponTransparency: HBoxContainer = $"%SetWeaponTransparency"
onready var SetEnemyTransparency: HBoxContainer = $"%SetEnemyTransparency"
onready var SetEnemyProjTransparency: HBoxContainer = $"%SetEnemyProjTransparency"
onready var SetGoldTransparency: HBoxContainer = $"%SetGoldTransparency"
onready var SetConsumableTransparency: HBoxContainer = $"%SetConsumableTransparency"
onready var SetStartingItemsNum: HBoxContainer = $"%SetStartingItemsNum"
onready var SetGMONum: HBoxContainer = $"%SetGMONum"

func _input(event) -> void:
    if visible and event.is_action_pressed("ui_cancel"):
        _on_BackButton_pressed()
        get_tree().set_input_as_handled()

func init() -> void:
    focus_before_created = get_focus_owner()
    scroll_container.show()
    back_button.show()
    back_button.grab_focus()
    init_values_from_progress_data()

func init_values_from_progress_data() -> void:
    var opt = ProgressData.optimize_settings
    StartingWeapons.pressed = opt.optimize_starting_weapons
    StartingItems.pressed = opt.optimize_starting_items
    OptimizePickUp.pressed = opt.optimize_optimize_pickup
    CurseStrength.pressed = opt.optimize_curse_strength
    NumberOptimize.pressed = opt.optimize_number_optimize
    Gmo.pressed = opt.optimize_gmo

    SetWeaponTransparency.set_value(opt.optimize_set_weapon_transparency)
    SetEnemyTransparency.set_value(opt.optimize_set_enemy_transparency)
    SetEnemyProjTransparency.set_value(opt.optimize_set_enemy_proj_transparency)
    SetGoldTransparency.set_value(opt.optimize_set_gold_transparency)
    SetConsumableTransparency.set_value(opt.optimize_set_consumable_transparency)
    SetStartingItemsNum.set_value(opt.optimize_set_starting_items_num)
    SetGMONum.set_value(opt.optimize_set_gmo_num)

func _on_BackButton_pressed() -> void:
    palette_manager.hide()
    focus_before_created.grab_focus()
    emit_signal("back_button_pressed")
    ProgressData.op_save_optimize_settings()

func _on_PaletteManagerButton_pressed() -> void:
    palette_manager.popup_centered()
    scroll_container.hide()
    back_button.hide()

func _on_PaletteManager_popup_hide() -> void:
    scroll_container.show()
    back_button.show()

func _on_MenuOptimizeSetOptions_hide() -> void:
    ProgressData.op_save_optimize_settings()

func _on_StartingWeapons_toggled(pressed: bool) -> void:
    ProgressData.optimize_settings.optimize_starting_weapons = pressed
func _on_StartingItems_toggled(pressed: bool) -> void:
    ProgressData.optimize_settings.optimize_starting_items = pressed
func _on_OptimizePickUp_toggled(pressed: bool) -> void:
    ProgressData.optimize_settings.optimize_optimize_pickup = pressed
func _on_CurseStrength_toggled(pressed: bool) -> void:
    ProgressData.optimize_settings.optimize_curse_strength = pressed
func _on_NumberOptimize_toggled(pressed: bool) -> void:
    ProgressData.optimize_settings.optimize_number_optimize = pressed
func _on_GMO_toggled(pressed: bool) -> void:
    ProgressData.optimize_settings.optimize_gmo = pressed

func _on_SetWeaponTransparency_value_changed(value: float) -> void:
    ProgressData.optimize_settings.optimize_set_weapon_transparency = value
func _on_SetEnemyTransparency_value_changed(value: float) -> void:
    ProgressData.optimize_settings.optimize_set_enemy_transparency = value
func _on_SetEnemyProjTransparency_value_changed(value: float) -> void:
    ProgressData.optimize_settings.optimize_set_enemy_proj_transparency = value
func _on_SetGoldTransparency_value_changed(value: float) -> void:
    ProgressData.optimize_settings.optimize_set_gold_transparency = value
func _on_SetConsumableTransparency_value_changed(value: float) -> void:
    ProgressData.optimize_settings.optimize_set_consumable_transparency = value
func _on_SetStartingItemsNum_value_changed(value: float) -> void:
    ProgressData.optimize_settings.optimize_set_starting_items_num = value
func _on_SetGMONum_value_changed(value: float) -> void:
    ProgressData.optimize_settings.optimize_set_gmo_num = value

func _on_PaletteManager_palette_changed() -> void:
    ProgressData.op_save_optimize_settings()

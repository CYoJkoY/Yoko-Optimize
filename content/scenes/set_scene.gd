extends Control

signal back_button_pressed

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

onready var RainbowGold: OptionButton = $"%RainbowGold"
onready var colors_names: Array = ProgressData.settings.opt_colors.keys()

# =========================== Init =========================== #
func _input(event) -> void:
    if self.visible and event.is_action_pressed("ui_cancel"):
        _on_BackButton_pressed()
        get_tree().set_input_as_handled()

func init() -> void:
    focus_before_created = get_focus_owner()
    back_button.grab_focus()

    init_values_from_progress_data()

func init_values_from_progress_data() -> void:
    StartingWeapons.pressed = ProgressData.settings.optimize_starting_weapons
    StartingItems.pressed = ProgressData.settings.optimize_starting_items
    OptimizePickUp.pressed = ProgressData.settings.optimize_optimize_pickup
    CurseStrength.pressed = ProgressData.settings.optimize_curse_strength
    NumberOptimize.pressed = ProgressData.settings.optimize_number_optimize
    Gmo.pressed = ProgressData.settings.optimize_gmo

    SetWeaponTransparency.set_value(ProgressData.settings.optimize_set_weapon_transparency)
    SetEnemyTransparency.set_value(ProgressData.settings.optimize_set_enemy_transparency)
    SetEnemyProjTransparency.set_value(ProgressData.settings.optimize_set_enemy_proj_transparency)
    SetGoldTransparency.set_value(ProgressData.settings.optimize_set_gold_transparency)
    SetConsumableTransparency.set_value(ProgressData.settings.optimize_set_consumable_transparency)
    SetStartingItemsNum.set_value(ProgressData.settings.optimize_set_starting_items_num)
    SetGMONum.set_value(ProgressData.settings.optimize_set_gmo_num)

    RainbowGold.select(colors_names.find(ProgressData.settings.optimize_rainbow_gold))

# =========================== Save =========================== #
func _on_BackButton_pressed() -> void:
    focus_before_created.grab_focus()
    emit_signal("back_button_pressed")

func _on_MenuOptimizeSetOptions_hide() -> void:
    ProgressData.save_settings()

# =========================== Load =========================== #
func _on_StartingWeapons_toggled(button_pressed: bool) -> void:
    ProgressData.settings.optimize_starting_weapons = button_pressed
func _on_StartingItems_toggled(button_pressed: bool) -> void:
    ProgressData.settings.optimize_starting_items = button_pressed
func _on_OptimizePickUp_toggled(button_pressed: bool):
    ProgressData.settings.optimize_optimize_pickup = button_pressed
func _on_CurseStrength_toggled(button_pressed: bool) -> void:
    ProgressData.settings.optimize_curse_strength = button_pressed
func _on_NumberOptimize_toggled(button_pressed: bool) -> void:
    ProgressData.settings.optimize_number_optimize = button_pressed
func _on_GMO_toggled(button_pressed: bool) -> void:
    ProgressData.settings.optimize_gmo = button_pressed

func _on_SetWeaponTransparency_value_changed(value: float) -> void:
    ProgressData.settings.optimize_set_weapon_transparency = value
func _on_SetEnemyTransparency_value_changed(value: float) -> void:
    ProgressData.settings.optimize_set_enemy_transparency = value
func _on_SetEnemyProjTransparency_value_changed(value: float) -> void:
    ProgressData.settings.optimize_set_enemy_proj_transparency = value
func _on_SetGoldTransparency_value_changed(value: float) -> void:
    ProgressData.settings.optimize_set_gold_transparency = value
func _on_SetConsumableTransparency_value_changed(value: float) -> void:
    ProgressData.settings.optimize_set_consumable_transparency = value
func _on_SetStartingItemsNum_value_changed(value: float) -> void:
    ProgressData.settings.optimize_set_starting_items_num = value
func _on_SetGMONum_value_changed(value: float) -> void:
    ProgressData.settings.optimize_set_gmo_num = value

func _on_RainbowGold_item_selected(index: int) -> void:
    ProgressData.settings.optimize_rainbow_gold = colors_names[index]

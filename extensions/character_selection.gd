extends "res://ui/menus/run/character_selection.gd"

const FONT_RESOURCE = preload("res://resources/fonts/actual/base/font_40_outline_thick.tres")
var _player_gmo_num: int = ProgressData.optimize_settings.optimize_set_gmo_num

# =========================== Extention =========================== #
func _on_element_focused(element: InventoryElement, inventory_player_index: int, displayPanelData: bool = true) -> void:
    if ProgressData.optimize_settings.optimize_gmo: _optimize_gmo_on_element_focused(element, inventory_player_index, displayPanelData)
    else :._on_element_focused(element, inventory_player_index, displayPanelData)

func _on_element_pressed(element: InventoryElement, inventory_player_index: int) -> void:
    if ProgressData.optimize_settings.optimize_gmo: _optimize_gmo_on_element_pressed(element, inventory_player_index)
    else :._on_element_pressed(element, inventory_player_index)

func _on_selections_completed() -> void:
    if ProgressData.optimize_settings.optimize_gmo: _optimize_gmo_on_selections_completed()
    else : ._on_selections_completed()

# =========================== Custom =========================== #
func _optimize_gmo_on_element_focused(element: InventoryElement, inventory_player_index: int, _displayPanelData: bool = true) -> void:
    var player_index = FocusEmulatorSignal.get_player_index(element)
    if player_index < 0:
        push_error("[CharacterSelection] Focus emulator signal not triggered")
        return

    if _player_characters[player_index] == null:
        _player_characters[player_index] = []

    if player_index == 0 and __restore_player0_element != null:
        if __restore_player0_element.is_visible_in_tree():
            Utils.call_deferred("focus_player_control", __restore_player0_element, player_index)
        __restore_player0_element = null
        return

    var character = element.item
    if character != null:
        RunData.add_item(character, player_index)

    op_base_on_element_focused(element, inventory_player_index, _player_characters[player_index].empty())

    if player_index >= 0:
        if _player_characters[player_index].empty():
            op_base_clear_selected_element(player_index)

        CoopService.listening_for_inputs = RunData.is_coop_run

    var locked_panel: Container = _get_locked_panels()[player_index]
    locked_panel.visible = !element.is_random and element.is_special
    if locked_panel.visible:
        locked_panel.player_color_index = player_index if RunData.is_coop_run else -1
        locked_panel.set_element(element.item, _get_reward_type())

    _info_panel.visible = !RunData.is_coop_run and !element.is_random
    if _info_panel.visible and _player_characters[player_index].empty() and player_index >= 0:
        update_info_panel(element.item)
    if character != null:
        RunData.remove_item(character, player_index)

func _optimize_gmo_on_element_pressed(element: InventoryElement, _inventory_player_index: int) -> void:
    var inventory_player_index = FocusEmulatorSignal.get_player_index(element)
    if inventory_player_index < 0: return

    if _player_characters[inventory_player_index] == null:
        _player_characters[inventory_player_index] = []

    if element.is_random:
        var available_elements: Array = []

        for elt in displayed_elements[0]:
            if elt.is_locked: continue

            available_elements.append(elt)

        var random_elt = Utils.get_rand_element(available_elements)
        _player_characters[inventory_player_index].append(random_elt.item)
        op_add_number_to_character(element)
    elif element.is_special:
        return
    else:
        _on_element_focused(element, _inventory_player_index)
        _player_characters[inventory_player_index].append(element.item)
        op_add_number_to_character(element)

    if _player_characters[inventory_player_index].size() >= _player_gmo_num:
        _set_selected_element(inventory_player_index)

func _optimize_gmo_on_selections_completed() -> void:
    if ProgressData.settings.zone_is_random: _setup_zone(ProgressData.settings.zone_selected)

    for player_index in RunData.get_player_count():
        var characters: Array = _player_characters[player_index]

        var selection_characters: Array = []
        for i in range(characters.size()):
            var character: CharacterData = characters[i]
            if character == null: continue

            if i == 0:
                RunData.add_character(character, player_index)
                selection_characters.append(character)
            else:
                var other_character: ItemCharacterData = ItemCharacterData.new()
                other_character.clone(character)

                ProgressData.op_add_gmo_character(other_character)

                RunData.add_item(other_character, player_index)
                selection_characters.append(other_character)

        RunData.selected_characters[player_index] = selection_characters

    if Utils.on_nintendo_nx_or_ounce and RunData.is_coop_run: OS.set_max_controller_count(RunData.get_player_count())

    match [ProgressData.optimize_settings.optimize_starting_items, RunData.some_player_has_weapon_slots()]:
        [true, _]: _change_scene(MenuData.item_selection_scene)
        [false, true]: _change_scene(MenuData.weapon_selection_scene)
        [false, false]: _change_scene(MenuData.difficulty_selection_scene)
            
# =========================== Method =========================== #
func op_add_number_to_character(element: InventoryElement) -> void:
    element.set_font(FONT_RESOURCE)

    if element.current_number == 1:
        if element._number_label.text == '':
            element._number_label.text = "x" + str(element.current_number)
            element._number_label.show()
        else: element.add_to_number()
    else: element.add_to_number()

func op_base_clear_selected_element(player_index: int) -> void:
    _get_panels()[player_index].selected = false
    _has_player_selected[player_index] = false
    _selections_completed_timer.stop()
    _player_characters[player_index] = []

func op_base_on_element_focused(element: InventoryElement, inventory_player_index: int, displayPanelData: bool = true) -> void:
    var player_index = FocusEmulatorSignal.get_player_index(element)
    
    if player_index < 0:
        player_index = inventory_player_index

    var panel = _get_panels()[player_index]
    if element.is_random:
        if displayPanelData:
            panel._show_random()
        panel.visible = true
    else:
        panel.visible = not element.is_special

    _latest_focused_element[player_index] = element
    if panel.visible and displayPanelData:
        _display_element_panel_data(element, player_index)

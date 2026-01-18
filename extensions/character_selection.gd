extends "res://ui/menus/run/character_selection.gd"

const FONT_RESOURCE = preload("res://resources/fonts/actual/base/font_40_outline_thick.tres")
var _player_gmo_num: int = ProgressData.settings.yztato_gmo_num

# =========================== Extention =========================== #
func _get_unlocked_elements(player_index: int) -> Array:
    var unlocked: Array = ._get_unlocked_elements(player_index)
    unlocked = _yztato_unlock_all_chars(unlocked, player_index)
    
    return unlocked

func _on_selections_completed() -> void :
    for player_index in RunData.get_player_count():
        var characters = _player_characters[player_index]
        
        if ProgressData.settings.yztato_gmo and typeof(characters) == TYPE_ARRAY:
            var selection_characters: Array = []
            for i in range(characters.size()):
                var character = characters[i]
                if character != null:
                    if i == 0:
                        RunData.add_character(character, player_index)
                        selection_characters.push_back(character)
                    else:
                        var other_character = ProgressData.Optimize.Scripts.ItemCharacterData.new()
                        other_character.my_id = character.my_id
                        other_character.unlocked_by_default = character.unlocked_by_default
                        other_character.can_be_looted = character.can_be_looted
                        other_character.icon = character.icon
                        other_character.name = character.name
                        other_character.tier = character.tier
                        other_character.value = character.value
                        other_character.effects = character.effects
                        other_character.tracking_text = character.tracking_text
                        other_character.is_lockable = character.is_lockable
                        other_character.unlock_codex_descr_after_get_it = character.unlock_codex_descr_after_get_it
                        other_character.is_cursed = character.is_cursed
                        other_character.curse_factor = character.curse_factor
                        other_character.max_nb = character.max_nb
                        other_character.item_appearances = character.item_appearances
                        other_character.tags = character.tags
                        other_character.replaced_by = character.replaced_by
                        other_character.wanted_tags = character.wanted_tags
                        other_character.banned_item_groups = character.banned_item_groups
                        other_character.banned_items = character.banned_items
                        other_character.starting_weapons = character.starting_weapons

                        RunData.add_item(other_character, player_index)
                        selection_characters.push_back(other_character)
            RunData.selected_characters[player_index] = selection_characters
        elif characters != null:
            RunData.add_character(characters, player_index)
    
    match [ProgressData.settings.yztato_starting_items, RunData.some_player_has_weapon_slots()]:
        [true,_]: 
            _change_scene(MenuData.item_selection_scene)
        [false,true]: 
            _change_scene(MenuData.weapon_selection_scene)
        [false,false]: 
            RunData.add_starting_items_and_weapons()
            _change_scene(MenuData.difficulty_selection_scene)

func _on_element_pressed(element: InventoryElement, inventory_player_index: int)->void :
    if not ProgressData.settings.yztato_gmo:
        ._on_element_pressed(element, inventory_player_index)
    else:
        _yztato_gmo_on_element_pressed(element, inventory_player_index)

func _on_element_focused(element: InventoryElement, inventory_player_index: int, displayPanelData: bool = true)->void :
    if not ProgressData.settings.yztato_gmo:
        ._on_element_focused(element, inventory_player_index, displayPanelData)
    else:
        _yztato_gmo_on_element_focused(element, inventory_player_index, displayPanelData)

# =========================== Custom =========================== #
func _yztato_unlock_all_chars(unlocked: Array, player_index: int) -> Array:
    if ProgressData.settings.yztato_unlock_all_chars:
        var all_unlocked: = []
        for element in _get_all_possible_elements(player_index):
            all_unlocked.push_back(element.my_id)
        return all_unlocked

    return unlocked

func _yztato_gmo_on_element_pressed(element: InventoryElement, inventory_player_index: int)->void:
    var player_index = FocusEmulatorSignal.get_player_index(element)
    if player_index < 0:
        return 
    
    if _player_characters[inventory_player_index] == null:
        _player_characters[inventory_player_index] = []

    if element.is_random:
        var available_elements: = []
        
        for elt in displayed_elements[inventory_player_index]:
            if not elt.is_locked:
                available_elements.push_back(elt)
        var character = Utils.get_rand_element(available_elements)
        _player_characters[inventory_player_index].append(character)
        _add_number_to_character(element)
    elif element.is_special:
        return 
    else:
        _player_characters[inventory_player_index].append(element.item)
        _add_number_to_character(element)

    if _player_characters[inventory_player_index].size() >= _player_gmo_num:
        _set_selected_element(inventory_player_index)

func _yztato_gmo_on_element_focused(element: InventoryElement, inventory_player_index: int, _displayPanelData: bool = true)->void:
    var player_index = FocusEmulatorSignal.get_player_index(element)
    if player_index < 0:
        push_error("Focus emulator signal not triggered")
        return 
    
    if player_index == 0 and __restore_player0_element != null:
        if __restore_player0_element.is_visible_in_tree():
            Utils.call_deferred("focus_player_control", __restore_player0_element, player_index)
        __restore_player0_element = null
        return 

    _base_on_element_focused(element, inventory_player_index, _player_characters[player_index] == null)

    if player_index >= 0:
        if _player_characters[player_index] == null or \
        (
            typeof(_player_characters[player_index]) == TYPE_ARRAY and \
            _player_characters[player_index].size() < ProgressData.settings.yztato_gmo_num

        ):
            _base_clear_selected_element(player_index)

        CoopService.listening_for_inputs = RunData.is_coop_run

    var locked_panel = _get_locked_panels()[player_index]
    locked_panel.visible = not element.is_random and element.is_special
    if locked_panel.visible:
        locked_panel.player_color_index = player_index if RunData.is_coop_run else - 1
        locked_panel.set_element(element.item, _get_reward_type())

    _info_panel.visible = not RunData.is_coop_run and not element.is_random
    if _info_panel.visible and _player_characters[player_index] == null and player_index >= 0:
        update_info_panel(element.item)

# =========================== Method =========================== #
func _add_number_to_character(element: InventoryElement)->void:
    element.set_font(FONT_RESOURCE)

    if element.current_number == 1:
        if element._number_label.text == '':
            element._number_label.text = "x" + str(element.current_number)
            element._number_label.show()
        else:
            element.add_to_number()
    else:
        element.add_to_number()

func _base_clear_selected_element(player_index: int)->void:
    _get_panels()[player_index].selected = false
    _has_player_selected[player_index] = false
    _selections_completed_timer.stop()

func _base_on_element_focused(element: InventoryElement, inventory_player_index: int, displayPanelData: bool = true)->void:
    var player_index = FocusEmulatorSignal.get_player_index(element)
    
    
    if player_index < 0:
        player_index = inventory_player_index

    var panel = _get_panels()[player_index]
    if element.is_random:
        panel._show_random()
        panel.visible = true
    else :
        panel.visible = not element.is_special

    _latest_focused_element[player_index] = element
    if panel.visible and displayPanelData:
        _display_element_panel_data(element, player_index)

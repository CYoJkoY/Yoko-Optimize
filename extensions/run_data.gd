extends "res://singletons/run_data.gd"

# ══════════════════════════════════════════ Extension ══════════════════════════════════════════ #
func reset(restart: bool = false) -> void:
    if ProgressData.optimize_settings.optimize_gmo or \
    ProgressData.optimize_settings.optimize_starting_items:
        _optimize_reset(restart)
    else : .reset(restart)

# ══════════════════════════════════════════ Custom ══════════════════════════════════════════ #
func _optimize_reset(restart: bool = false) -> void:
    current_run_accessibility_settings = ProgressData.settings.enemy_scaling.duplicate()
    constant_projectile = ProgressData.settings.constant_projectile_option
    is_ban_mode_active = ProgressData.settings.ban_mode_toggled

    reset_background()
    reset_weapons_dmg_dealt()
    reset_weapons_tracked_value_this_wave()
    reset_wave_caches()
    reset_run_caches()

    for player_index in tracked_item_effects.size():
        tracked_item_effects[player_index] = init_tracked_effects()

    if not restart:
        set_player_count(1, true)
        set_coop_run(false)
        is_endless_run = false
        enabled_dlcs = ProgressData.get_active_dlc_ids()
        current_difficulty = 0
        ProgressData.reset_dlc_resources_to_active_dlcs()
    else:
        var characters := []
        for player_data in players_data:
            characters.append(player_data.current_character)

        var selected_weapons: Array = []
        var selected_items: Array = []
        var optimize_selected_items: Array = [] # * Starting items
        var optimize_selected_other_characters: Array = [] # * GMO
        for player_data in players_data:
            selected_weapons.append(player_data.selected_weapon)
            selected_items.append(player_data.selected_item)
            optimize_selected_items.append(player_data.optimize_selected_items) # * Starting items
            optimize_selected_other_characters.append(player_data.optimize_selected_other_characters) # * GMO

        set_player_count(get_player_count(), true)
        for i in characters.size():
            var character = characters[i]
            add_character(character, i)

        for i in selected_weapons.size():
            var selected_weapon = selected_weapons[i]
            if selected_weapon:
                add_weapon(selected_weapon, i, true)

        for i in selected_items.size():
            var selected_item = selected_items[i]
            if selected_item:
                add_item(selected_item, i, true)

        # * Starting items
        for i in range(optimize_selected_items.size()):
            var optimize_selected_item: Array = optimize_selected_items[i]
            op_add_starting_items(optimize_selected_item, i)

        # * GMO
        for i in range(optimize_selected_other_characters.size()):
            var optimize_selected_other_character: Array = optimize_selected_other_characters[i]
            op_add_starting_characters(optimize_selected_other_character, i)

        add_starting_items_and_weapons()

        var difficulty = ItemService.get_element(ItemService.difficulties, Keys.empty_hash, current_difficulty)

        for effect in difficulty.effects:
            effect.apply(0)

    _reset_per_wave_properties()
    DebugService.reset_for_new_run()

    reset_elites_spawn()
    reset_events_nightmare()
    init_elites_spawn()
    init_events_nightmare()
    init_bosses_spawn()

    resumed_from_state_in_shop = false
    shop_effects_checked = false
    bonus_gold = 0
    total_bonus_gold = 0
    retries = 0
    elites_killed_this_run = []
    bosses_killed_this_run = []
    loot_aliens_killed_this_run = 0
    challenges_completed_this_run = []
    run_won = false
    all_last_wave_bosses_killed = false
    locked_shop_items = [[], [], [], []]
    difficulty_unlocked = -1
    max_endless_wave_record_beaten = -1
    current_wave = DebugService.starting_wave

    if DebugService.randomize_waves:
        current_wave = Utils.randi_range(9, 20)

    instant_waves = DebugService.instant_waves
    invulnerable = DebugService.invulnerable

    for player_index in get_player_count():
        players_data[player_index].uses_ban = RunData.is_ban_mode_active
        players_data[player_index].remaining_ban_token = RunData.BAN_MAX_TOKEN

    TempStats.reset()
    LinkedStats.reset()
    ItemService.init_unlocked_pool()

# ══════════════════════════════════════════ Method ══════════════════════════════════════════ #
func op_add_starting_items(item_datas: Array, player_index: int) -> void:
    if item_datas.empty(): return

    var optimize_selected_items: Array = []
    for item_data in item_datas:
        if !item_data: continue

        var item: ItemData = item_data.duplicate()
        optimize_selected_items.append(item)
        add_item(item, player_index)

    players_data[player_index].optimize_selected_items = optimize_selected_items

func op_add_starting_characters(other_character_datas: Array, player_index: int) -> void:
    if other_character_datas.empty(): return

    var optimize_selected_other_characters: Array = []
    for other_character_data in other_character_datas:
        if !other_character_data: continue

        var other_character: ItemCharacterData = other_character_data.duplicate()
        optimize_selected_other_characters.append(other_character)
        add_item(other_character, player_index)

    players_data[player_index].optimize_selected_other_characters = optimize_selected_other_characters

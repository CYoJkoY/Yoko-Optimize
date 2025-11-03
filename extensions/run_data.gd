extends "res://singletons/run_data.gd"

var selected_items: Array = [[], [], [], []]
var selected_characters: Array = [[], [], [], []]

# =========================== Extention =========================== #
func _ready():
	_yztato_unlock_all_challenges()

func reset(restart: bool = false)->void :
	if ProgressData.settings.yztato_gmo or \
	ProgressData.settings.yztato_starting_items:
		_yztato_reset(restart)
	else:
		.reset(restart)

# =========================== Custom =========================== #
func _yztato_unlock_all_challenges() -> void:
	if ProgressData.settings.yztato_unlock_all_challenges:
		for chal in ChallengeService.challenges:
			ChallengeService.complete_challenge(chal.my_id)

func _yztato_reset(restart: bool = false)->void :
	current_run_accessibility_settings = ProgressData.settings.enemy_scaling.duplicate()
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
		is_coop_run = false
		is_endless_run = false
		enabled_dlcs = ProgressData.get_active_dlc_ids()
		current_difficulty = 0
		ProgressData.reset_dlc_resources_to_active_dlcs()
	else :
		var characters: = []
		for player_data in players_data:
			characters.push_back(player_data.current_character)

		var selected_weapons: = []
		for player_data in players_data:
			selected_weapons.push_back(player_data.selected_weapon)

		var selected_items_chars: Array = [[], [], [], []]
		for player_index in players_data.size():
			selected_items_chars[player_index].append_array(selected_items[player_index])
			selected_items_chars[player_index].append_array(selected_characters[player_index])

		set_player_count(get_player_count(), true)
		for i in characters.size():
			var character = characters[i]
			add_character(character, i)

		for i in selected_weapons.size():
			var selected_weapon = selected_weapons[i]
			if selected_weapon:
				var _weapon = add_weapon(selected_weapon, i, true)

		for i in selected_items_chars.size():
			var selected_items_chars_player: Array = selected_items_chars[i]
			var items_count: int = selected_items_chars_player.size()
			if items_count > 0:
				for j in range(items_count - 1):
					add_item(selected_items_chars_player[j], i)

		add_starting_items_and_weapons()

		var difficulty = ItemService.get_element(ItemService.difficulties, "", current_difficulty)

		
		for effect in difficulty.effects:
			effect.apply(0)

	_reset_per_wave_properties()
	DebugService.reset_for_new_run()

	init_elites_spawn()
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
	difficulty_unlocked = - 1
	max_endless_wave_record_beaten = - 1
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

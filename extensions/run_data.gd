extends "res://singletons/run_data.gd"

# =========================== Extention =========================== #
func _ready():
	_yztato_unlock_all_challenges()

func add_character(character: CharacterData, player_index: int)->void :
	if ProgressData.settings.item_appearances_hide == true:
		_yztato_add_character(character, player_index)
	else:
		.add_character(character, player_index)

func add_item(item: ItemData, player_index: int)->void :
	if ProgressData.settings.item_appearances_hide == true:
		_yztato_add_item(item, player_index)
	else:
		.add_item(item, player_index)

# =========================== Custom =========================== #
func _yztato_add_character(character: CharacterData, player_index: int) -> void:
	players_data[player_index].current_character = character
	players_data[player_index].items.push_back(character)
	_update_item_caches(character, player_index)
	apply_item_effects(character, player_index)
	add_item_displayed(character, player_index)
	update_item_related_effects(player_index)
	LinkedStats.reset_player(player_index)
	_check_bait_chal(character.my_id, player_index)
	check_scavenger_chal()

func _yztato_add_item(item: ItemData, player_index: int) -> void:
	players_data[player_index].items.push_back(item)
	_update_item_caches(item, player_index)
	apply_item_effects(item, player_index)
	update_item_related_effects(player_index)
	LinkedStats.reset_player(player_index)
	_check_bait_chal(item.my_id, player_index)
	check_scavenger_chal()

func _yztato_unlock_all_challenges() -> void:
	if ProgressData.settings.yztato_unlock_all_challenges:
		for chal in ChallengeService.challenges:
			ChallengeService.complete_challenge(chal.my_id)

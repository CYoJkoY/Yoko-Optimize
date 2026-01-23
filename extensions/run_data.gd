extends "res://singletons/run_data.gd"

var selected_items: Array = [[], [], [], []]
var selected_characters: Array = [[], [], [], []]

# =========================== Extention =========================== #
func _ready():
    _yztato_unlock_all_challenges()

# =========================== Custom =========================== #
func _yztato_unlock_all_challenges() -> void:
    if ProgressData.settings.yztato_unlock_all_challenges:
        for chal in ChallengeService.challenges:
            ChallengeService.complete_challenge(chal.my_id)

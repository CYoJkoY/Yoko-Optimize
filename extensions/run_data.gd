extends "res://singletons/run_data.gd"

# =========================== Extension =========================== #
func _ready():
    _optimize_unlock_all_challenges()

# =========================== Custom =========================== #
func _optimize_unlock_all_challenges() -> void:
    if ProgressData.settings.optimize_unlock_all_challenges:
        ChallengeService._generate_hashes()
        for chal in ChallengeService.challenges:
            ChallengeService.complete_challenge(chal.get_my_id_hash())

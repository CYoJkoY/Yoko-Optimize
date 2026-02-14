extends "res://weapons/weapon_stats/weapon_stats.gd"

# =========================== Extension =========================== #
func get_dmg_text_with_scaling_stats(base_stats: Resource, p_scaling_stats: Array, nb_projectiles: int, player_index: int, effects: Array) -> String:
    var dmg_text: String =.get_dmg_text_with_scaling_stats(base_stats, p_scaling_stats, nb_projectiles, player_index, effects)
    if ProgressData.settings.yztato_number_optimize:
        dmg_text = Utils.ncl_get_dmg_text_with_scaling_stats(damage, p_scaling_stats, base_stats.damage, {"nb": nb_projectiles, "player_index": player_index, "effects": effects})
    return dmg_text

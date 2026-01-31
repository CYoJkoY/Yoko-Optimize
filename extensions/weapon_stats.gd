extends "res://weapons/weapon_stats/weapon_stats.gd"

# =========================== Extension =========================== #
func get_dmg_text_with_scaling_stats(base_stats: Resource, p_scaling_stats: Array, nb_projectiles: int, player_index: int, effects: Array) -> String:
    var dmg_text: String = .get_dmg_text_with_scaling_stats(base_stats, p_scaling_stats, nb_projectiles, player_index, effects)
    if ProgressData.settings.yztato_number_optimize:
        dmg_text = _yztato_get_dmg_text_with_scaling_stats(base_stats, p_scaling_stats, nb_projectiles, player_index, effects)
    return dmg_text

# =========================== Custom =========================== #
func _yztato_get_dmg_text_with_scaling_stats(base_stats: Resource, p_scaling_stats: Array, nb_projectiles: int, player_index: int, effects: Array) -> String:
    var displayed_damage = damage

    for effect in effects:
        if effect is PlayerHealthStatEffect and effect.key == "stat_damage":
            displayed_damage += effect.get_bonus_damage(player_index)

    var a = get_signed_col_a(displayed_damage, base_stats.damage)
    var dmg_text = a + ProgressData.Optimize.Methods.format_number(displayed_damage) + col_b

    var text = dmg_text if nb_projectiles == 1 else dmg_text + "x" + str(nb_projectiles)

    if displayed_damage != base_stats.damage:
        var initial_dmg_text = ProgressData.Optimize.Methods.format_number(base_stats.damage) if nb_projectiles == 1 else ProgressData.Optimize.Methods.format_number(base_stats.damage) + "x" + str(nb_projectiles)
        text += get_init_a() + initial_dmg_text + col_b

    text += " (" + WeaponService.get_scaling_stats_icon_text(p_scaling_stats) + ")"

    return text

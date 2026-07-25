extends "res://ui/menus/shop/stats_container.gd"

# =========================== Extension=========================== #
func _ready() -> void:
	_optimize_tertiary_stat_ready()

func _optimize_tertiary_stat_ready() -> void:
	for stat in ItemService.stats:
		if stat.get("is_tertiary_stat") == null or \
		stat.get("is_tertiary_stat") == false:
			continue

		var tertiary_stat = _secondary_stats.get_child(0).duplicate()
		tertiary_stat.key = stat.stat_name.to_upper()
		tertiary_stat.reverse = stat.reverse
		_secondary_stats.add_child(tertiary_stat)
		tertiary_stat.disable_focus()


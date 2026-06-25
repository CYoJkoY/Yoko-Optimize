extends "res://singletons/utils.gd"

const THRESHOLDS = [
    [1000000000000000000, "Qi"],
    [1000000000000000, "Qa"],
    [1000000000000, "T"],
    [1000000000, "B"],
    [1000000, "M"],
    [1000, "K"]
]

# =========================== Methods =========================== #
func opt_format_number(value: int) -> String:
    if value < 1000: return str(value)

    var abs_val: int = int(abs(value))
    var suffix: String = ""
    var base: int = 1

    for item in THRESHOLDS:
        if abs_val < item[0]: continue

        base = item[0]
        suffix = item[1]
        break

    var value_formatted: float = abs_val / float(base)
    var result: String = str(stepify(value_formatted, 0.01))
    if value < 0: result = "-" + result

    return result + suffix

func opt_get_stat_small_icon(stat_hash: int) -> Resource:
    var stat: Resource = opt_get_stat(stat_hash)

    if stat: return stat.small_icon

    return null

func opt_get_stat(stat_hash: int) -> Resource:
    for stat in ItemService.stats:
        if stat.stat_hash != stat_hash or \
        stat.get("is_tertiary_stat") == null: continue

        return stat

    return null

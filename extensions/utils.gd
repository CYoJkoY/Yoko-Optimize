extends "res://singletons/utils.gd"

# =========================== Methods =========================== #
func opt_format_number(value: int) -> String:
    if value < 1000: return str(value)
    
    var abs_value = abs(value)
    var suffix = ""
    var base = 1
    
    if abs_value >= 1000000000000000000:
        suffix = "Qi"
        base = 1000000000000000000
    elif abs_value >= 1000000000000000:
        suffix = "Qa"
        base = 1000000000000000
    elif abs_value >= 1000000000000:
        suffix = "T"
        base = 1000000000000
    elif abs_value >= 1000000000:
        suffix = "B"
        base = 1000000000
    elif abs_value >= 1000000:
        suffix = "M"
        base = 1000000
    elif abs_value >= 1000:
        suffix = "K"
        base = 1000

    var integer_part: int = abs_value / base
    var decimal_part: int = (abs_value % base) * 100 / base

    if decimal_part >= 100:
        integer_part += 1
        decimal_part = 0

    var result = str(integer_part)
    if decimal_part > 0:
        if decimal_part % 10 == 0: result = "%s.%s" % [result, str(decimal_part / 10)]
        else: result = "%s.%s" % [result, str(decimal_part)]

    if value < 0: result = "-%s" % [result]

    return result + suffix

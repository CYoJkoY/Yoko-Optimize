extends "res://singletons/utils.gd"

# =========================== Extension =========================== #
func opt_format_number(value: int) -> String:
    if value < 1000:
        return str(value)
    
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

    var integer_part = abs_value / base
    var decimal_part = (abs_value % base) / (base / 100)
    
    var result = str(integer_part)
    if decimal_part > 0:
        var dec_str = str(decimal_part).pad_zeros(2)
        result += "." + dec_str.rstrip("0")
    
    if value < 0:
        result = "-" + result
        
    return result + suffix

extends "res://singletons/utils.gd"

const scales: Array = [
    {"value": 1000000000000000.0, "suffix": "P"},
    {"value": 1000000000000.0, "suffix": "T"},
    {"value": 1000000000.0, "suffix": "B"},
    {"value": 1000000.0, "suffix": "M"},
    {"value": 1000.0, "suffix": "K"}
]

# =========================== Extension =========================== #

# =========================== Custom =========================== #

# =========================== Method =========================== #
func format_number(number: float) -> String:
    var is_negative: bool = number < 0
    var abs_number: float = abs(number)
    
    var result: String = str(abs_number)
    if abs_number >= 1000.0:
        for scale in scales:
            if abs_number >= scale.value:
                result = str(stepify(abs_number / scale.value, 0.01)) + scale.suffix
                break
    
    if is_negative and abs_number != 0.0:
        result = "-" + result
    
    return result

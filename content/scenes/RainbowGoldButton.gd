extends OptionButton

func _ready() -> void:
    for colors_name in ProgressData.settings.opt_colors.keys():
        add_item(colors_name)

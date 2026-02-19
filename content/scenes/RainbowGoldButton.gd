extends OptionButton

func _ready():
    for colors_name in ProgressData.settings.yz_colors.keys():
        add_item(colors_name)

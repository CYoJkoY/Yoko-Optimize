extends Node

const MYMODNAME_MOD_DIR = "Yoko-Optimize/"
const MYMODNAME_LOG = "Yoko-Optimize"

var dir: String = ""
var content_dir: String = ""
var ext_dir: String = ""

# =========================== Extension =========================== #
func _init():
    dir = ModLoaderMod.get_unpacked_dir() + MYMODNAME_MOD_DIR
    content_dir = dir + "content/"
    ext_dir = dir + "extensions/"
    
    # Add Classes
    var classes: Array = [
        {
            "base": "CharacterData",
            "class": "ItemCharacterData",
            "language": "GDScript",
            "path": "res://mods-unpacked/Yoko-Optimize/content/scripts/item_character.gd"
        },
    ]

    ModLoaderMod.register_global_classes_from_array(classes)

    # Add Extensions
    var extensions: Array = [
        
        "utils.gd",
        # Mods's Methods

        "enemy.gd",
        # SETTING: set_enemy_transparency

        "shooting_attack_behavior.gd",
        # SETTING: set_enemy_proj_transparency

        "consumable.gd",
        # SETTING: set_consumable_transparency
        #           optimize_pickup[ 1/2 ]

        "gold.gd",
        # SETTING: set_gold_transparency
        #          rainbow_gold
        #          optimize_pickup[ 2/2 ]

        "progress_data.gd",
        # Mod's Contents
        # SETTINGS

        "secondary_stat_container.gd",
        # SETTING: number_optimize[ 1/8 ]
        # Secondary Stats' Icons

        "stats_container.gd",
        # SETTING: tertiary_stats

        "melee_weapon.gd",
        # SETTING: set_weapon_transparency[ 1/2 ]

        "ranged_weapon.gd",
        # SETTING: set_weapon_transparency[ 2/2 ]

        "title_screen_menus.gd",
        # SETTINGS

        "main_menu.gd",
        # SETTINGS

        "button_with_icon.gd",
        # SETTING: number_optimize[ 2/8 ]

        "ui_gold.gd",
        # SETTING: number_optimize[ 3/8 ]

        "ui_bonus_gold.gd",
        # SETTING: number_optimize[ 4/8 ]

        "stat_container.gd",
        # SETTING: number_optimize[ 5/8 ]

        "gold_label.gd",
        # SETTING: number_optimize[ 6/8 ]

        "weapon_stats.gd",
        # SETTING: number_optimize[ 7/8 ]

        "reroll_button.gd",
        # SETTING: number_optimize[ 8/8 ]

        "item_description.gd",
        # SETTING: curse_strength

        "weapon_selection.gd",
        # SETTING: starting_weapons

        "character_selection.gd",
        # SETTING: GMO[ 1/2 ]

        "menu_data.gd",
        # SETTING: starting_items[ 1/2 ]

        "run_data.gd",
        # SETTING: starting_items[ 2/2 ],
        #          GMO[ 2/2 ]

    ]
    
    for path in extensions:
        var extension_path = ext_dir + path
        ModLoaderMod.install_script_extension(extension_path)

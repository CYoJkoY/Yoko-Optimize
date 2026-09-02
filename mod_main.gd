extends Node

const AUTHORNAME_MODNAME_DIR = "Yoko-Optimize/"
const AUTHORNAME_MODNAME_LOG_NAME = "Yoko-Optimize"

var mod_dir_path: String = ""
var content_dir: String = ""
var ext_dir: String = ""

# ══════════════════════════════════════════ Extension ══════════════════════════════════════════ #
func _init():
    mod_dir_path = ModLoaderMod.get_unpacked_dir() + AUTHORNAME_MODNAME_DIR
    content_dir = mod_dir_path + "content/"
    ext_dir = mod_dir_path + "extensions/"

    # Add Extensions
    install_script_extensions()

# ══════════════════════════════════════════ Custom ══════════════════════════════════════════ #
func install_script_extensions() -> void:
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
        #          rainbow_gold[ 1/2 ]
        #          optimize_pickup[ 2/2 ]

        "progress_data.gd",
        # Mod's Contents
        # SETTINGS
        # SETTING: GMO[ 1/5 ],
        #          rainbo_gold[ 2/2 ]

        "secondary_stat_container.gd",
        # SETTING: number_optimize[ 1/8 ]
        # Secondary Stats' Icons

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
        # SETTING: GMO[ 2/5 ]

        "menu_data.gd",
        # SETTING: starting_items

        "player_run_data.gd",
        # SETTING: GMO[ 3/5 ]

        "run_data.gd",
        # SETTING: GMO[ 4/5 ]

        "item_service.gd"
        # SETTING: GMO[ 5/5 ]

    ]

    for path in extensions:
        var extension_path = ext_dir.plus_file(path)
        ModLoaderMod.install_script_extension(extension_path)

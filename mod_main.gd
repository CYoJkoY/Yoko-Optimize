extends Node

const MYMODNAME_MOD_DIR = "Yoko-Optimize/"
const MYMODNAME_LOG = "Yoko-Optimize"

var dir = ""
var ext_dir = ""
var trans_dir = ""

# =========================== Extension =========================== #
func _init():
    dir = ModLoaderMod.get_unpacked_dir() + MYMODNAME_MOD_DIR
    trans_dir = dir + "translations/"
    ext_dir = dir + "extensions/"

    ModLoaderMod.add_translation(trans_dir + "Optimize.en.translation")
    ModLoaderMod.add_translation(trans_dir + "Optimize.zh_Hans_CN.translation")
    
    var extensions: Array = [
        
        "enemy.gd",
        # SETTING : set_enemy_transparency
        
        "shooting_attack_behavior.gd",
        # SETTING : set_enemy_proj_transparency
        
        "consumable.gd",
        # SETTING : set_consumable_transparency, optimize_pickup
        
        "gold.gd",
        # SETTING : set_gold_transparency, rainbow_gold, optimize_pickup
        
        "progress_data.gd",
        # Mod's Contents
        # SETTINGS
        
        "run_data.gd",
        # SETTING : unlock_all_challenges,
        
        "character_selection.gd",
        # SETTING : unlock_all_chars

        "difficulty_selection.gd",
        # SETTING : unlock_difficulties
        
        "secondary_stat_container.gd",
        # SETTING : number_optimize[ 1/8 ]
        # Secondary Stats' Icons
        
        "stats_container.gd",
        # SETTING : tertiary_stats
        
        "melee_weapon.gd",
        # SETTING : set_weapon_transparency
        
        "ranged_weapon.gd",
        # SETTING : set_weapon_transparency
        
        "title_screen_menus.gd",
        # SETTINGS
        
        "main_menu.gd",
        # SETTINGS

        "main.gd",
        # Display Hit Protection
        
        "button_with_icon.gd",
        # SETTING : number_optimize[ 2/8 ]

        "ui_gold.gd",
        # SETTING : number_optimize[ 3/8 ]

        "ui_bonus_gold.gd",
        # SETTING : number_optimize[ 4/8 ]

        "stat_container.gd",
        # SETTING : number_optimize[ 5/8 ]

        "gold_label.gd",
        # SETTING : number_optimize[ 6/8 ]

        "weapon_stats.gd",
        # SETTING : number_optimize[ 7/8 ]

        "reroll_button.gd",
        # SETTING : number_optimize[ 8/8 ]
   
        "item_description.gd",
        # SETTING : curse_strength
        
        "weapon_selection.gd",
        # SETTING : starting_weapons
        
    ]
    
    for path in extensions:
        var extension_path = ext_dir + path
        ModLoaderMod.install_script_extension(extension_path)

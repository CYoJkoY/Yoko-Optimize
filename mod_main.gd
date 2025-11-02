extends Node

const MYMODNAME_MOD_DIR = "Yoko-Optimize/"
const MYMODNAME_LOG = "Yoko-Optimize"

var dir = ""
var ext_dir = ""
var trans_dir = ""

# =========================== Extention =========================== #
func _init():
	ModLoaderLog.info("========== Add Translation ==========", MYMODNAME_LOG)
	dir = ModLoaderMod.get_unpacked_dir() + MYMODNAME_MOD_DIR
	trans_dir = dir + "translations/"
	ext_dir = dir + "extensions/"
	
	#######################################
	########## Add translations ##########
	#####################################
	ModLoaderMod.add_translation(trans_dir + "YzTato_Optimize.en.translation")
	ModLoaderMod.add_translation(trans_dir + "YzTato_Optimize.zh_Hans_CN.translation")
	
	ModLoaderLog.info("========== Add Translation Done ==========", MYMODNAME_LOG)
	
	#####################################
	########## Add extensions ##########
	###################################
	var extensions = [
		
		"enemy.gd",
		# SETTING : set_enemy_transparency
		
		"shooting_attack_behavior.gd",
		# SETTING : set_enemy_proj_transparency
		
		"menu_data.gd", 
		
		"consumable.gd",
		# SETTING : set_consumable_transparency, optimize_pickup
		
		"gold.gd",
		# SETTING : set_gold_transparency, rainbow_gold, optimize_pickup
		
		"progress_data.gd",
		# Mod's Contents
		# SETTINGS
		
		"run_data.gd",
		# SETTING : item_appearances_hide, unlock_all_challenges
		
		"character_selection.gd",
		# SETTING : unlock_all_chars, starting_items, gmo
		
		"difficulty_selection.gd",
		# SETTING : unlock_difficulties
		
		"secondary_stat_container.gd",
		# Secondary Stats' Icons
		
		"stats_container.gd",
		# SETTING : tertiary_stats
		
		"weapon_selection.gd",
		# SETTING : starting_weapons
		
		"melee_weapon.gd",
		# SETTING : set_weapon_transparency
		
		"ranged_weapon.gd",
		# SETTING : set_weapon_transparency
		
		"title_screen_menus.gd",
		# SETTINGS
		
		"main_menu.gd",
		# SETTINGS
		
	]
	
	var extensions2: Array = [
		
		["item_description.gd", "res://ui/menus/shop/item_description.gd"],
		# SETTING : curse_strength
		
	]
	
	for path in extensions:
		ModLoaderMod.install_script_extension(ext_dir + path)
	for path2 in extensions2:
		YZ_extend_script(path2, ext_dir)

func YZ_extend_script(script: Array, _ext_dir: String) -> void:
	var child_script_path: String = _ext_dir + script[0]
	var parent_script_path: String = script[1]
	
	var mod_id: String = _ModLoaderPath.get_mod_dir(get_script().resource_path)
	
	if not ModLoaderStore.saved_extension_paths.has(mod_id):
		ModLoaderStore.saved_extension_paths[mod_id] = []
	ModLoaderStore.saved_extension_paths[mod_id].append(child_script_path)
	
	if not File.new().file_exists(child_script_path):
		ModLoaderLog.error("The child script path '%s' does not exist" % [child_script_path], MYMODNAME_LOG)
		return

	_apply_script_extension_now(child_script_path, parent_script_path)

func _apply_script_extension_now(child_script_path: String, parent_script_path: String) -> void:
	var child_script: Script = load(child_script_path)
	child_script.set_meta("extension_script_path", child_script_path)
	child_script.reload(true)

	var parent_script: Script = load(parent_script_path)

	if not ModLoaderStore.saved_scripts.has(parent_script_path):
		ModLoaderStore.saved_scripts[parent_script_path] = []
		ModLoaderStore.saved_scripts[parent_script_path].append(parent_script)

	ModLoaderStore.saved_scripts[parent_script_path].append(child_script)
	
	ModLoaderLog.info("Installing script extension: %s <- %s" % [parent_script_path, child_script_path], MYMODNAME_LOG)

	child_script.take_over_path(parent_script_path)

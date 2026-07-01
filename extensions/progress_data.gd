extends "res://singletons/progress_data.gd"

const MOD_ID: String = "Yoko-Optimize"
const SETTINGS_CONFIG_NAME: String = "optimize_settings"
const DEFAULT_SCHEMA: Dictionary = {
    "type": "object"
}

var optimize_settings: Dictionary = {}
var current_opt_color: Array = []

# =========================== Extension =========================== #
func _init() -> void:
    call_deferred("_optimize_init")

# =========================== Custom =========================== #
func _optimize_init() -> void:
    _init_mod_config()
    _load_optimize_settings()
    op_update_runtime_palette()

func _init_mod_config() -> void:
    if !ModLoaderStore.mod_data.has(MOD_ID):
        ModLoaderLog.error("Mod not found in ModLoaderStore.", MOD_ID)
        return

    var mod_manifest: ModManifest = ModLoaderStore.mod_data[MOD_ID].manifest
    if typeof(mod_manifest.config_schema) != TYPE_DICTIONARY:
        mod_manifest.config_schema = DEFAULT_SCHEMA

    var configs: Dictionary = ModLoaderStore.mod_data[MOD_ID].configs

    if !configs.has("default"):
        var default_config_path: String = _ModLoaderPath.get_path_to_mod_configs_dir(MOD_ID).plus_file("default.json")
        var default_config: ModConfig = ModConfig.new(MOD_ID, {}, default_config_path, DEFAULT_SCHEMA)
        default_config.name = "default"
        default_config.schema = DEFAULT_SCHEMA
        default_config.is_valid = true
        configs["default"] = default_config
        ModLoaderLog.info("Placeholder default config created.", MOD_ID)

    if !configs.has(SETTINGS_CONFIG_NAME):
        var config_file_path: String = _ModLoaderPath.get_path_to_mod_configs_dir(MOD_ID).plus_file("%s.json" % SETTINGS_CONFIG_NAME)
        var file: File = File.new()

        if file.file_exists(config_file_path):
            var err: int = file.open(config_file_path, File.READ)
            if err == OK:
                var content: String = file.get_as_text()
                file.close()

                var parse: JSONParseResult = JSON.parse(content)
                if parse.error == OK and typeof(parse.result) == TYPE_DICTIONARY:
                    var user_config: ModConfig = ModConfig.new(MOD_ID, parse.result, config_file_path, DEFAULT_SCHEMA)
                    if user_config.is_valid:
                        user_config.name = SETTINGS_CONFIG_NAME
                        configs[SETTINGS_CONFIG_NAME] = user_config
                        ModLoaderLog.info("Loaded existing settings from disk.", MOD_ID)
                        return
                    else:
                        ModLoaderLog.error("Existing settings file failed validation, replacing with defaults.", MOD_ID)
                else:
                    ModLoaderLog.error("Existing settings file is corrupt, replacing with defaults.", MOD_ID)
            else:
                ModLoaderLog.error("Cannot read existing settings file, replacing with defaults.", MOD_ID)

        var default_data: Dictionary = op_get_default_optimize_settings()
        var user_config: ModConfig = ModConfig.new(MOD_ID, default_data, config_file_path, DEFAULT_SCHEMA)
        if user_config.is_valid:
            user_config.name = SETTINGS_CONFIG_NAME
            configs[SETTINGS_CONFIG_NAME] = user_config
            user_config.save_to_file()
            ModLoaderLog.info("New user settings config created.", MOD_ID)
        else:
            ModLoaderLog.error("Failed to create valid settings config. Using in-memory defaults.", MOD_ID)
            optimize_settings = default_data

func _load_optimize_settings() -> void:
    var configs: Dictionary = ModLoaderStore.mod_data[MOD_ID].configs
    var user_config: ModConfig = configs.get(SETTINGS_CONFIG_NAME) as ModConfig
    if !user_config:
        ModLoaderLog.error("Settings config not found. Using defaults.", MOD_ID)
        optimize_settings = op_get_default_optimize_settings()
        return

    var user_data: Dictionary = user_config.data
    var default_data: Dictionary = op_get_default_optimize_settings()

    optimize_settings = default_data.duplicate()
    for key in user_data:
        if optimize_settings.has(key):
            optimize_settings[key] = user_data[key]

    var need_save: bool = false
    for key in default_data:
        if !user_data.has(key):
            need_save = true
            break
    if need_save:
        user_config.data = optimize_settings
        user_config.save_to_file()
        ModLoaderLog.info("New default keys merged and saved.", MOD_ID)

func _save_optimize_settings() -> void:
    var user_config: ModConfig = ModLoaderConfig.get_config(MOD_ID, SETTINGS_CONFIG_NAME)
    if !user_config:
        ModLoaderLog.error("Cannot save settings, config not found.", MOD_ID)
        return
    user_config.data = optimize_settings
    var updated: ModConfig = ModLoaderConfig.update_config(user_config)
    if !updated:
        ModLoaderLog.error("Failed to save settings.", MOD_ID)
    else:
        ModLoaderLog.debug("Settings saved.", MOD_ID)

# =========================== Method =========================== #
func op_get_default_optimize_settings() -> Dictionary:
    return {
        "optimize_unlock_difficulties": false,
        "optimize_unlock_all_chars": false,
        "optimize_unlock_all_challenges": false,
        "optimize_optimize_pickup": false,
        "optimize_starting_weapons": false,
        "optimize_starting_items": false,
        "optimize_curse_strength": true,
        "optimize_number_optimize": true,
        "optimize_hit_protection_display": false,
        "optimize_gmo": false,
        "optimize_gmo_characters": [],
        "optimize_set_weapon_transparency": 1.0,
        "optimize_set_enemy_transparency": 1.0,
        "optimize_set_enemy_proj_transparency": 1.0,
        "optimize_set_gold_transparency": 1.0,
        "optimize_set_consumable_transparency": 1.0,
        "optimize_set_starting_items_num": 1,
        "optimize_set_gmo_num": 2,
        "optimize_palettes": {
            "default": {
                "name": "Default",
                "colors": ["#990000", "#009900", "#000099", "#999900", "#990099", "#009999"]
            }
        },
        "optimize_active_palette_ids": ["default"],
    }

func op_save_optimize_settings() -> void:
    _save_optimize_settings()

func op_update_runtime_palette() -> void:
    current_opt_color.clear()
    var palettes: Dictionary = optimize_settings.get("optimize_palettes", {})
    var active_ids: Array = optimize_settings.get("optimize_active_palette_ids", [])
    for id in active_ids:
        if !palettes.has(id):
            continue
        var colors: Array = palettes[id].get("colors", [])
        current_opt_color.append_array(colors)
    if current_opt_color.empty():
        current_opt_color = ["#FFFFFF"]

func op_update_runtime_gmo_characters() -> Array:
    var gmo_characters_id: Array = optimize_settings.get("optimize_gmo_characters", [])
    var gmo_characters: Array = []
    if gmo_characters_id.empty():
        ModLoaderLog.info("No GMO character IDs configured.", "Yoko-Optimize")
        return gmo_characters

    ModLoaderLog.info("Updating GMO characters from %d IDs." % [gmo_characters_id.size()], "Yoko-Optimize")
    for gmo_character_id in gmo_characters_id:
        var stripped_id: String = gmo_character_id.replace("item_", "")
        var ori_character: CharacterData = ItemService.get_element_safe(ItemService.characters, stripped_id)
        if ori_character == null:
            ModLoaderLog.warning("Original character not found for ID: '%s' (stripped: '%s')" % [gmo_character_id, stripped_id], "Yoko-Optimize")
            continue

        var gmo_character: ItemCharacterData = ItemCharacterData.new()
        gmo_character.clone(ori_character)
        gmo_characters.append(gmo_character)

    ModLoaderLog.info("Generated %d GMO character(s)." % [gmo_characters.size()], "Yoko-Optimize")
    return gmo_characters

func op_get_palettes() -> Dictionary:
    return optimize_settings.get("optimize_palettes", {})

func op_get_active_palette_ids() -> Array:
    return optimize_settings.get("optimize_active_palette_ids", [])

func op_set_active_palette_ids(ids: Array) -> void:
    optimize_settings["optimize_active_palette_ids"] = ids
    _save_optimize_settings()
    op_update_runtime_palette()

func op_add_palette(name: String, colors: Array) -> String:
    var palettes: Dictionary = optimize_settings["optimize_palettes"]
    var id: String = str(Time.get_ticks_msec())
    palettes[id] = {"name": name, "colors": colors}
    _save_optimize_settings()
    return id

func op_remove_palette(id: String) -> void:
    var palettes: Dictionary = optimize_settings["optimize_palettes"]
    if !palettes.has(id):
        return
    palettes.erase(id)
    var active: Array = optimize_settings["optimize_active_palette_ids"]
    if active.has(id):
        active.erase(id)
        op_update_runtime_palette()
    _save_optimize_settings()

func op_update_palette(id: String, new_name: String, new_colors: Array) -> void:
    var palettes: Dictionary = optimize_settings["optimize_palettes"]
    if !palettes.has(id):
        return
    palettes[id]["name"] = new_name
    palettes[id]["colors"] = new_colors
    if optimize_settings["optimize_active_palette_ids"].has(id):
        op_update_runtime_palette()
    _save_optimize_settings()

func op_get_runtime_colors() -> Array:
    return current_opt_color

func op_add_gmo_character(gmo_character: ItemCharacterData) -> void:
    if optimize_settings["optimize_gmo_characters"].has(gmo_character.my_id): return

    optimize_settings["optimize_gmo_characters"].append(gmo_character.my_id)
    _save_optimize_settings()

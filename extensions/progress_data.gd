extends "res://singletons/progress_data.gd"

const OPTIMIZE_CONFIG_FILE: String = "optimize_config.json"

var optimize_settings: Dictionary = {}
var optimize_config_path: String = ""
var current_opt_color: Array = []

# =========================== Extension =========================== #
func _ready() -> void:
    _optimize_ready()

# =========================== Custom =========================== #
func _optimize_ready():
    optimize_config_path = SAVE_DIR + OPTIMIZE_CONFIG_FILE
    optimize_settings = op_get_default_optimize_settings()
    op_load_optimize_settings()
    op_update_runtime_palette()

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

func op_update_runtime_palette() -> void:
    current_opt_color.clear()
    var palettes: Dictionary = optimize_settings.get("optimize_palettes", {})
    var active_ids: Array = optimize_settings.get("optimize_active_palette_ids", [])
    for id in active_ids:
        if !palettes.has(id): continue

        var colors: Array = palettes[id].get("colors", [])
        current_opt_color.append_array(colors)

    if current_opt_color.empty(): current_opt_color = ["#FFFFFF"]

func op_get_palettes() -> Dictionary:
    return optimize_settings.get("optimize_palettes", {})

func op_get_active_palette_ids() -> Array:
    return optimize_settings.get("optimize_active_palette_ids", [])

func op_set_active_palette_ids(ids: Array) -> void:
    optimize_settings["optimize_active_palette_ids"] = ids
    op_save_optimize_settings()
    op_update_runtime_palette()

func op_add_palette(name: String, colors: Array) -> String:
    var palettes: Dictionary = optimize_settings["optimize_palettes"]
    var id: String = str(Time.get_ticks_msec())
    palettes[id] = {"name": name, "colors": colors}
    op_save_optimize_settings()
    return id

func op_remove_palette(id: String) -> void:
    var palettes: Dictionary = optimize_settings["optimize_palettes"]
    if !palettes.has(id): return

    palettes.erase(id)
    var active = optimize_settings["optimize_active_palette_ids"]
    if active.has(id):
        active.erase(id)
        op_update_runtime_palette()
    op_save_optimize_settings()

func op_update_palette(id: String, new_name: String, new_colors: Array) -> void:
    var palettes: Dictionary = optimize_settings["optimize_palettes"]
    if !palettes.has(id): return

    palettes[id]["name"] = new_name
    palettes[id]["colors"] = new_colors
    if optimize_settings["optimize_active_palette_ids"].has(id): op_update_runtime_palette()
    op_save_optimize_settings()

func op_get_runtime_colors() -> Array:
    return current_opt_color

func op_load_optimize_settings() -> void:
    var file: File = File.new()
    if !file.file_exists(optimize_config_path):
        ModLoaderLog.info("No config file found, using defaults.", "Yoko-Optimize")
        return

    var err: int = file.open(optimize_config_path, File.READ)
    if err != OK:
        ModLoaderLog.error("Could not open config file: %s" % [optimize_config_path], "Yoko-Optimize")
        return

    var content: String = file.get_as_text()
    file.close()

    var parse: JSONParseResult = JSON.parse(content)
    if parse.error != OK:
        ModLoaderLog.error("Error parsing config: %s" % [parse.error_string], "Yoko-Optimize")
        return

    var data: Dictionary = parse.result
    if typeof(data) != TYPE_DICTIONARY:
        ModLoaderLog.error("Config is not a dictionary", "Yoko-Optimize")
        return

    for key in data.keys():
        if !optimize_settings.has(key): continue

        optimize_settings[key] = data[key]

    ModLoaderLog.info("Config loaded successfully.", "Yoko-Optimize")

func op_save_optimize_settings() -> void:
    var tmp_path: String = optimize_config_path + ".tmp"
    var file: File = File.new()
    var err: int = file.open(tmp_path, File.WRITE)
    if err != OK:
        ModLoaderLog.error("Could not create temp file: %s" % [tmp_path], "Yoko-Optimize")
        return

    var json_str: String = JSON.print(optimize_settings, "  ")
    file.store_string(json_str)
    file.close()

    var dir: Directory = Directory.new()
    if dir.file_exists(optimize_config_path):
        err = dir.remove(optimize_config_path)
        if err != OK:
            ModLoaderLog.error("Could not remove old config file: %s" % [optimize_config_path], "Yoko-Optimize")
            return

    err = dir.rename(tmp_path, optimize_config_path)
    if err != OK:
        ModLoaderLog.error("Could not rename temp file to config file: %s" % [optimize_config_path], "Yoko-Optimize")
        return

    ModLoaderLog.info("Mod settings saved.", "Yoko-Optimize")

extends "res://main.gd"

var YzTimers: Array = []

# ui_entry
var UIHitProtectionScenes = {}
const UI_HIT_PROTECTION_SCENE = preload("res://mods-unpacked/Yoko-Optimize/content/scenes/ui_hit_protection.tscn")

# =========================== Extension =========================== #
func _on_EntitySpawner_players_spawned(players: Array) -> void:
    ._on_EntitySpawner_players_spawned(players)
    _yztato_hit_protection_display()

    _yztato_start_ui_update_timer()

func clean_up_room() -> void :
    for timer in YzTimers: timer.stop()
    .clean_up_room()

# =========================== Custom =========================== #
func _yztato_start_ui_update_timer() -> void:
    var timer = Timer.new()
    timer.wait_time = 0.2
    timer.autostart = true
    timer.connect("timeout", self, "yz_update_all_ui_stats")
    add_child(timer)
    YzTimers.append(timer)

func _yztato_hit_protection_display() -> void:
    if !ProgressData.settings.yztato_hit_protection_display: return
    
    for i in _players.size():
        if _players[i] in UIHitProtectionScenes:
            continue
            
        var UIHitProtectionInstance = UI_HIT_PROTECTION_SCENE.instance()
        match i:
            0,2: UIHitProtectionInstance.alignment = BoxContainer.ALIGN_BEGIN
            1,3: UIHitProtectionInstance.alignment = BoxContainer.ALIGN_END
        
        var player_ui = _players_ui[i]
        if !is_instance_valid(player_ui) or !is_instance_valid(player_ui.hud_container):
            continue

        var after_gold_index = player_ui.hud_container.get_children().find(player_ui.gold) + 1
        player_ui.hud_container.add_child(UIHitProtectionInstance)
        player_ui.hud_container.move_child(UIHitProtectionInstance, after_gold_index)
        
        UIHitProtectionInstance.update_value(_players[i]._hit_protection)
        UIHitProtectionScenes[_players[i]] = UIHitProtectionInstance

func _yztato_hit_protection_process() -> void:
    if !ProgressData.settings.yztato_hit_protection_display: return
    
    for player in _players:
        if player in UIHitProtectionScenes and \
        is_instance_valid(UIHitProtectionScenes[player]):
            UIHitProtectionScenes[player].update_value(player._hit_protection)

# =========================== Method =========================== #
func yz_update_all_ui_stats() -> void:
    _yztato_hit_protection_process()

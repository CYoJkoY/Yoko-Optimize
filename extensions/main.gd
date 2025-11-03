extends "res://main.gd"

var UIHitProtectionScenes = {}
const UI_HIT_PROTECTION_SCENE = preload("res://mods-unpacked/Yoko-Optimize/content/scenes/ui_hit_protection.tscn")

func _on_EntitySpawner_players_spawned(players: Array) -> void:
	._on_EntitySpawner_players_spawned(players)
	
	for i in range(_players.size()):
		if _players[i] in UIHitProtectionScenes:
			continue
			
		var UIHitProtectionInstance = UI_HIT_PROTECTION_SCENE.instance()
		match i:
			0,2: UIHitProtectionInstance.alignment = BoxContainer.ALIGN_BEGIN
			1,3: UIHitProtectionInstance.alignment = BoxContainer.ALIGN_END
		
		var player_ui = _players_ui[i]
		var gold_index = player_ui.hud_container.get_children().find(player_ui.gold)
		player_ui.hud_container.add_child(UIHitProtectionInstance)
		
		if gold_index != -1:
			player_ui.hud_container.move_child(UIHitProtectionInstance, gold_index + 1)
		
		UIHitProtectionInstance.update_value(_players[i]._hit_protection)
		UIHitProtectionScenes[_players[i]] = UIHitProtectionInstance

func _process(_delta: float) -> void:
	for player in _players:
		if player in UIHitProtectionScenes and \
		is_instance_valid(UIHitProtectionScenes[player]):
			UIHitProtectionScenes[player].update_value(player._hit_protection)
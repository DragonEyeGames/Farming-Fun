extends Node2D

func _on_door_body_entered(_body: Node2D) -> void:
	var lastSeen
	if ResourceLoader.exists("user://player_data.tres"):
		var data = ResourceLoader.load("user://player_data.tres") as PlayerData
		lastSeen = data.lastLocation
	var player = PlayerData.new()
	player.inventory=GameManager.playerInventory
	player.money=GameManager.playerMoney
	player.lastLocation=lastSeen
	ResourceSaver.save(player, "user://player_data.tres")
	get_tree().call_deferred("change_scene_to_file", "res://Scenes/Main.tscn")

extends Node2D


func _on_door_body_entered(_body: Node2D) -> void:
	var player = PlayerData.new()
	player.inventory=GameManager.playerInventory
	ResourceSaver.save(player, "user://player_data.tres")
	get_tree().change_scene_to_file("res://Main.tscn")

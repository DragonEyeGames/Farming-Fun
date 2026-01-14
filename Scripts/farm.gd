extends Node2D


func _ready() -> void:
	GameManager.plantable=$Ground
	GameManager.ySort=$"../YSort"
	await get_tree().process_frame
	await get_tree().process_frame
	for child in $Plants.get_children():
		child.reparent($"../YSort")

func _on_signal_bus_tick() -> void:
	for plant in get_tree().get_nodes_in_group("Crop"):
		plant.tick()
	await get_tree().process_frame
	for child in $Plants.get_children():
		if(child.animation!="empty"):
			child.reparent($"../YSort")

extends Node2D


func _ready() -> void:
	await get_tree().process_frame
	await get_tree().process_frame
	for child in $Plants.get_children():
		if(child.animation!="empty"):
			child.reparent($"../YSort")
		else:
			print(child.animation)

func _on_signal_bus_tick() -> void:
	for child in $Plants.get_children():
		child.tick()
	await get_tree().process_frame
	for child in $Plants.get_children():
		if(child.animation=="ready"):
			child.reparent($"../YSort")

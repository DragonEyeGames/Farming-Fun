extends Node2D



func _on_signal_bus_tick() -> void:
	for child in $Plants.get_children():
		child.tick()

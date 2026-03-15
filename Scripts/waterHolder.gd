extends Node2D

@export var maxWater=5.0
@export var refillMethod: GameManager.inventoryItem
@export var water:=5.0

func _process(_delta: float) -> void:
	$Sprites/WaterControl/Water.position.y=lerp(33.254, 13.615, water/maxWater)

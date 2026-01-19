extends Node2D

@export var maxFood=5.0
@export var foodType: GameManager.inventoryItem
@export var food:=5.0

func _process(_delta: float) -> void:
	$Sprites/FoodControl/Food.position.y=lerp(33.254, 13.615, food/maxFood)

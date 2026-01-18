extends Sprite2D

@export var maxFood=5
@export var foodType: GameManager.inventoryItem
@export var food:=5

func _process(_delta: float) -> void:
	$ColorRect.visible=food<=0

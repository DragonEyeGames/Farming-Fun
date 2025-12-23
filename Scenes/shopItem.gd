extends Control

@export var item: GameManager.inventoryItem
@export var cost: int

func _ready() -> void:
	var itemName = GameManager.inventoryItem.keys()[item]
	var itemText = str(itemName)
	itemText = itemText.replace("_", " ")
	$Item.text=str(itemText)
	$Cost.text=str(cost)

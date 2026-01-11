extends Control

@export var item: GameManager.inventoryItem
@export var cost: int

func _ready() -> void:
	var itemName = GameManager.inventoryItem.keys()[item]
	var itemText = str(itemName)
	itemText = itemText.replace("_", " ")
	$Item.text=str(itemText)
	$Cost.text=str(cost)


func _on_mouse_entered() -> void:
	var tween=create_tween()
	tween.tween_property(self, "scale", Vector2(1.05, 1.05), .1)


func _on_mouse_exited() -> void:
	var tween=create_tween()
	tween.tween_property(self, "scale", Vector2.ONE, .1)


func _on_pressed() -> void:
	pass
	
func success():
	var tween=create_tween()
	tween.tween_property($ColorRect, "color", Color.html('9d5f24'), .05)
	await get_tree().create_timer(0.05).timeout
	var tween2=create_tween()
	tween2.tween_property($ColorRect, "color", Color.html("#b8936d"), .05)
	
func fail():
	var tween=create_tween()
	tween.tween_property($ColorRect, "color", Color.INDIAN_RED, .05)
	await get_tree().create_timer(0.05).timeout
	var tween2=create_tween()
	tween2.tween_property($ColorRect, "color", Color.html("#b8936d"), .05)

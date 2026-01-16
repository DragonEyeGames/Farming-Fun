extends Node2D

var playerEntered:=false

func interact():
	GameManager.addItem(GameManager.inventoryItem.Egg, 1)
	queue_free()

func _on_area_2d_body_entered(body: Node2D) -> void:
	body.interacting.append(self)


func _on_area_2d_body_exited(body: Node2D) -> void:
	if(self in body.interacting):
		body.interacting.erase(self)

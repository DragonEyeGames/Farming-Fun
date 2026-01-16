extends Node2D

var playerEntered:=false

func _process(delta: float) -> void:
	if(Input.is_action_just_pressed("Interact") and playerEntered):
		GameManager.addItem(GameManager.inventoryItem.Raddish_Seeds, 1)
		queue_free()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if(body is Player):
		playerEntered=true


func _on_area_2d_body_exited(body: Node2D) -> void:
	if(body is Player):
		playerEntered=false

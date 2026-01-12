extends Sprite2D


func interact():
	print("sleeping")

func _on_area_2d_body_entered(body: Node2D) -> void:
	body.interacting.append(self)


func _on_area_2d_body_exited(body: Node2D) -> void:
	if(self in body.interacting):
		body.interacting.erase(self)

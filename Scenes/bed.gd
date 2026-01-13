extends Sprite2D

var player

func interact():
	player.sleeping=true
	print("schlep")
	$"../Night".play("darken")
	await get_tree().create_timer(4).timeout
	GameManager.day+=1
	GameManager.time=.3
	$"../Night".play("lighten")
	await get_tree().create_timer(4).timeout
	player.sleeping=false
	player.canMove=true

func _on_area_2d_body_entered(body: Node2D) -> void:
	body.interacting.append(self)
	player=body


func _on_area_2d_body_exited(body: Node2D) -> void:
	if(self in body.interacting):
		body.interacting.erase(self)

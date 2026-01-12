extends Node2D

var tick:=0.0

var playerEntered:=false

func _process(delta: float) -> void:
	tick+=delta
	if(tick>=10):
		tick-=10
		var children= $FishHolder.get_children()
		var fish=children.pick_random()
		fish.play("splash-" + str(randi_range(1, 2)))
		fish.position=Vector2(randi_range(-4, 38), randi_range(13, 44))
		fish.flip_h=randi_range(1, 2)==1
	
func interact():
	if(GameManager.itemSelected("watering")):
		GameManager.selectedItem.amount=GameManager.limited[GameManager.selectedItem.item]


func _on_refill_area_body_entered(body: Node2D) -> void:
	body.interacting.append(self)


func _on_refill_area_body_exited(body: Node2D) -> void:
	if(self in body.interacting):
		body.interacting.erase(self)

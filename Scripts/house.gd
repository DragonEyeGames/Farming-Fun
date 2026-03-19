extends Node2D

var playerEntered=false
var mainScene
var toPlay = []
var playing=false

func _process(_delta: float) -> void:
	if(playing==false and len(toPlay)>=1):
		$Door.play(toPlay[0])
		toPlay.remove_at(0)
	if(playerEntered and Input.is_action_just_pressed("Interact")):
		mainScene.transport("res://Scenes/house.tscn")

func _on_area_2d_body_entered(body: Node2D) -> void:
	if(body is Player):
		playerEntered=true
		if(not playing):
			playing=true
			$Door.play("open")
		else:
			toPlay.append("open")


func _on_area_2d_body_exited(body: Node2D) -> void:
	if(body is Player):
		playerEntered=false
		if(not playing):
			playing=true
			$Door.play("close")
		else:
			toPlay.append("close")


func _on_door_animation_finished() -> void:
	if($Door.animation=="open"):
		$Door.play("opened")
	if($Door.animation=="close"):
		$Door.play("closed")
	playing=false

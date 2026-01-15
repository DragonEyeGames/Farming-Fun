extends Node2D

var playerEntered=false
var mainScene

func _process(_delta: float) -> void:
	if(playerEntered and Input.is_action_just_pressed("Interact")):
		mainScene.transport("res://Scenes/house.tscn")

func _on_area_2d_body_entered(body: Node2D) -> void:
	if(body is Player):
		playerEntered=true


func _on_area_2d_body_exited(body: Node2D) -> void:
	if(body is Player):
		playerEntered=false

extends Sprite2D

var state=""
var animationPlaying:=false
var playerCollided:=false

var mainScene

func _process(_delta: float) -> void:
	if(animationPlaying==false and state!=""):
		$Door.play(state)
		animationPlaying=true
		state=""
	if(playerCollided and Input.is_action_just_pressed("Interact")):
		mainScene.transport("res://Scenes/windmill.tscn")

func _on_area_2d_body_entered(_body: Node2D) -> void:
	state="open"
	playerCollided=true


func _on_area_2d_body_exited(_body: Node2D) -> void:
	state="close"
	playerCollided=false


func _on_door_animation_finished() -> void:
	animationPlaying=false

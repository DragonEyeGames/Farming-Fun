extends Node2D

var direction=0
var playerEntered=false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if(direction!=0 and len($Bottom.get_overlapping_bodies())==0 and len($Top.get_overlapping_bodies())==0):
		if(direction==-1):
			$AnimationPlayer.play("close-down")
			direction=0
			playerEntered=false
		elif(direction==-1):
			$AnimationPlayer.play("close-up")
			direction=0
			playerEntered=false


func _on_bottom_body_entered(_body: Node2D) -> void:
	if(playerEntered==false):
		playerEntered=true
		direction=1
		$AnimationPlayer.play("open-up")


func _on_bottom_body_exited(_body: Node2D) -> void:
	if(playerEntered==true and direction==-1):
		playerEntered=false
		$AnimationPlayer.play("close-down")
		direction=0


func _on_top_body_entered(_body: Node2D) -> void:
	if(playerEntered==false):
		playerEntered=true
		direction=-1
		$AnimationPlayer.play("open-down")


func _on_top_body_exited(_body: Node2D) -> void:
	if(playerEntered==true and direction==1):
		playerEntered=false
		$AnimationPlayer.play("close-up")
		direction=0

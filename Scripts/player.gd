extends CharacterBody2D

var state="idle"
var direction="down"
var canMove:=true
var interacting:=[]
var sprite: AnimatedSprite2D
var pickedUp:=false

func _ready() -> void:
	sprite = $Sprite
	GameManager.player=self

func _process(_delta: float) -> void:
	if(not canMove):
		return
	#if(Input.is_action_just_pressed("Interact")):
	velocity = (Input.get_vector("Left", "Right", "Up", "Down")).normalized()*80
	move_and_slide()
	if(velocity.x<0):
		direction="side"
		sprite.flip_h=true
	elif(velocity.x>0):
		sprite.flip_h=false
		direction="side"
	elif(velocity.y>0):
		direction="down"
	elif(velocity.y<0):
		direction="up"
	if(velocity!=Vector2.ZERO):
		state="walk"
	else:
		state="idle"
		
	var animation = state + "-" + direction
	if(pickedUp):
		animation = "picked-" + animation
	if(sprite.animation!=animation):
		sprite.play(animation)
	if(Input.is_action_just_pressed("Interact") and len(interacting)>=1):
		interacting[0].interact()
		interacting.remove_at(0)
		canMove=false
		sprite.play("pickup-" + direction)


func _on_sprite_animation_finished() -> void:
	if(sprite.animation=="walk-up"):
		sprite.flip_h=!sprite.flip_h
		sprite.play("walk-up")
	if(sprite.animation=="walk-down"):
		sprite.flip_h=!sprite.flip_h
		sprite.play("walk-down")
	if(sprite.animation=="picked-walk-down"):
		sprite.flip_h=!sprite.flip_h
		sprite.play("picked-walk-down")
	if(sprite.animation=="picked-walk-up"):
		sprite.flip_h=!sprite.flip_h
		sprite.play("picked-walk-up")
	if("pickup" in sprite.animation):
		canMove=true

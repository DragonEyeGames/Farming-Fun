extends CharacterBody2D

var sprite: AnimatedSprite2D
var navAgent
@export var speed=200
@export var topLeft: Vector2
@export var bottomRight: Vector2
@export var globalized:=false
@export var home: Vector2
@export var egg: PackedScene
var recalculating:=false
var currentVelocity:=Vector2.ZERO
var currentDirection="left"

enum states {
	WANDERING,
	IDLE,
	SLEEP
}

var currentState=states.WANDERING


func _ready() -> void:
	navAgent=$NavigationAgent2D
	sprite=$Sprite
	if(globalized!=true):
		globalized=true
		bottomRight=to_global(bottomRight)
		topLeft=to_global(topLeft)
		home=to_global(home)
	await get_tree().process_frame
	makePath()
	stateControlling()
	eggRandom()
	
func eggRandom():
	await get_tree().create_timer(randf_range(60, 120)).timeout
	spawnEgg()
	eggRandom()
	
func spawnEgg():
	var newEgg=egg.instantiate()
	get_parent().add_child(newEgg)
	newEgg.global_position=global_position

func _process(_delta: float) -> void:
	if(Input.is_action_just_pressed("1")):
		currentState=states.SLEEP
		sleepPath()
	if(Input.is_action_just_pressed("2")):
		currentState=states.WANDERING
		makePath()
	if(Input.is_action_just_pressed("3")):
		currentState=states.IDLE
	match currentState:
		states.WANDERING:
			if(currentVelocity!=Vector2.ZERO):
				if(abs(currentVelocity.x)>=abs(currentVelocity.y)):
					if(currentVelocity.x<0):
						currentDirection="left"
						sprite.play("left")
					else:
						currentDirection="right"
						sprite.play("right")
				else:
					if(currentVelocity.y<0):
						currentDirection="up"
						sprite.play("up")
					else:
						currentDirection="down"
						sprite.play("down")
			else:
				sprite.play(currentDirection+"Idle")
		states.IDLE:
			sprite.play(currentDirection+"Idle")
		states.SLEEP:
			if(currentVelocity!=Vector2.ZERO):
				if(abs(currentVelocity.x)>=abs(currentVelocity.y)):
					if(currentVelocity.x<0):
						currentDirection="left"
						sprite.play("left")
					else:
						currentDirection="right"
						sprite.play("right")
				else:
					if(currentVelocity.y<0):
						currentDirection="up"
						sprite.play("up")
					else:
						currentDirection="down"
						sprite.play("down")
			else:
				sprite.play(currentDirection+"Idle")

func _physics_process(_delta: float) -> void:
	if(currentState==states.WANDERING):
		if navAgent.is_navigation_finished() and not recalculating:
			recalculating=true
			await get_tree().create_timer(randf_range(.5, 3)).timeout
			recalculating=false
			makePath()
			return
		var dir = to_local(navAgent.get_next_path_position()).normalized()
		velocity = dir*speed
		if(recalculating):
			velocity=Vector2.ZERO
		move_and_slide()
		currentVelocity=velocity
	elif(currentState==states.SLEEP):
		var dir = to_local(navAgent.get_next_path_position()).normalized()
		velocity = dir*speed
		if(navAgent.is_navigation_finished()):
			velocity=Vector2.ZERO
		move_and_slide()
		currentVelocity=velocity

func makePath():
	if(currentState==states.SLEEP):
		return
	var targetPos=Vector2.ZERO
	targetPos.x=randf_range(topLeft.x, bottomRight.x)
	targetPos.y=randf_range(topLeft.y, bottomRight.y)
	navAgent.target_position=targetPos
	await navAgent.path_changed
	
	var points = navAgent.get_current_navigation_path()
	var length = 0.0

	for i in range(points.size() - 1):
		length += points[i].distance_to(points[i + 1])

	if length < 40:
		# Too short — cancel the move
		makePath()
		
func sleepPath():
	var targetPos=home
	navAgent.target_position=targetPos
	await navAgent.path_changed
		
func stateControlling():
	await get_tree().create_timer(randf_range(5, 20)).timeout
	if(currentState==states.WANDERING):
		currentState=states.IDLE
	elif(currentState==states.IDLE):
		currentState=states.WANDERING
	stateControlling()

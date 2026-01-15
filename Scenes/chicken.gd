extends CharacterBody2D

var sprite: AnimatedSprite2D
var navAgent
@export var speed=200
@export var topLeft: Vector2
@export var bottomRight: Vector2
@export var globalized:=false
var recalculating:=false
var currentVelocity:=Vector2.ZERO
var currentDirection="left"


func _ready() -> void:
	navAgent=$NavigationAgent2D
	sprite=$Sprite
	if(globalized!=true):
		globalized=true
		bottomRight=to_global(bottomRight)
		topLeft=to_global(topLeft)
		print("globalized")
	await get_tree().process_frame
	print(topLeft)
	print(bottomRight)
	makePath()

func _process(_delta: float) -> void:
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

func makePath():
	var targetPos=Vector2.ZERO
	targetPos.x=randf_range(topLeft.x, bottomRight.x)
	targetPos.y=randf_range(topLeft.y, bottomRight.y)
	navAgent.target_position=targetPos
	await navAgent.path_changed
	
	var points = navAgent.get_current_navigation_path()
	var length = 0.0

	for i in range(points.size() - 1):
		length += points[i].distance_to(points[i + 1])

	if length < 20:
		# Too short — cancel the move
		makePath()

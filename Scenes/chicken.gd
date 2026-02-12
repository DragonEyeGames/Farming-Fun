extends CharacterBody2D

var sprite: AnimatedSprite2D
var navAgent
@export var speed=200
@export var topLeft: Vector2
@export var bottomRight: Vector2
@export var globalized:=false
@export var home: Vector2
@export var egg: PackedScene
@export var food: Vector2
@export var water: Vector2
var maxFood=2
var maxWater=1.0
var currentFood = 2.0
var currentWater = 1.0
var recalculating:=false
var currentVelocity:=Vector2.ZERO
var currentDirection="left"
var foodRepository
var waterRepository

enum states {
	WANDERING,
	IDLE,
	SLEEP,
	EATING,
	DRINKING
}

var currentState=states.WANDERING


func _ready() -> void:
	Engine.time_scale=5
	currentFood=randf_range(maxFood-0.5, maxFood+0.5)
	currentWater=randf_range(maxWater-0.25, maxWater+0.25)
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

func _process(delta: float) -> void:
	print(currentState)
	currentFood-=delta/60
	currentWater-=delta/60
	if(Input.is_action_just_pressed("1")):
		currentState=states.SLEEP
		sleepPath()
	if(Input.is_action_just_pressed("2")):
		currentState=states.WANDERING
		makePath()
	if(Input.is_action_just_pressed("3")):
		currentState=states.IDLE
	if(Input.is_action_just_pressed("4")):
		currentState=states.EATING
		eatPath()
	if(Input.is_action_just_pressed("5")):
		currentState=states.DRINKING
		print(currentState)
		waterPath()
	match currentState:
		states.WANDERING:
			if(currentVelocity!=Vector2.ZERO):
				if(currentVelocity.x<0):
					currentDirection="left"
					sprite.play("left")
				else:
					currentDirection="right"
					sprite.play("right")
			else:
				sprite.play(currentDirection+"Idle")
		states.IDLE:
			sprite.play(currentDirection+"Idle")
		states.SLEEP:
			if(currentVelocity!=Vector2.ZERO):
				if(currentVelocity.x<0):
					currentDirection="left"
					sprite.play("left")
				else:
					currentDirection="right"
					sprite.play("right")
			else:
				sprite.play(currentDirection+"Idle")
		states.EATING:
			if(currentVelocity!=Vector2.ZERO):
				if(currentVelocity.x<0):
					currentDirection="left"
					sprite.play("left")
				else:
					currentDirection="right"
					sprite.play("right")
			else:
				sprite.play(currentDirection+"Idle")
			if(foodRepository!=null):
				foodRepository.food-=1
				currentFood+=1
				foodRepository=null
				currentState=states.WANDERING
		states.DRINKING:
			if(currentVelocity!=Vector2.ZERO):
				if(currentVelocity.x<0):
					currentDirection="left"
					sprite.play("left")
				else:
					currentDirection="right"
					sprite.play("right")
			else:
				sprite.play(currentDirection+"Idle")
			if(waterRepository!=null):
				waterRepository.water-=.5
				currentWater+=.5
				waterRepository=null
				currentState=states.WANDERING

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
	elif(currentState==states.EATING):
		var dir = to_local(navAgent.get_next_path_position()).normalized()
		velocity = dir*speed
		if(navAgent.is_navigation_finished()):
			velocity=Vector2.ZERO
		move_and_slide()
		currentVelocity=velocity
	elif(currentState==states.DRINKING):
		var dir = to_local(navAgent.get_next_path_position()).normalized()
		velocity = dir*speed
		if(navAgent.is_navigation_finished()):
			velocity=Vector2.ZERO
		move_and_slide()
		currentVelocity=velocity

func makePath():
	if(currentState==states.SLEEP or currentState==states.EATING or currentState==states.DRINKING):
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
		
func eatPath():
	var targetPos=food
	navAgent.target_position=targetPos
	await navAgent.path_changed
	
func waterPath():
	var targetPos=water
	navAgent.target_position=targetPos
	await navAgent.path_changed
	
func stateControlling():
	await get_tree().create_timer(randf_range(5, 10)).timeout
	var random = randi_range(1, 20)
	if(currentState==states.IDLE or currentState==states.WANDERING):
		if(currentFood>1 or (currentFood>.3 and randi_range(1, 2)==2)):
			if(random<=7):
				currentState=states.IDLE
				print("idle")
			else:#lif(random<=14):
				currentState=states.WANDERING
				print("wander")
				makePath()
			#elif(random<=17):
				#currentState=states.SLEEP
				#sleepPath()
				#print("Bed")
		else:
			currentState=states.EATING 
			eatPath()
			print("HOm Now")
		if(currentWater>.5 or (currentWater>.15 and randi_range(1, 2)==2)):
			if(random<=7):
				currentState=states.IDLE
				print("idle")
			else:#lif(random<=14):
				currentState=states.WANDERING
				print("wander")
				makePath()
			#elif(random<=17):
				#currentState=states.SLEEP
				#sleepPath()
				#print("Bed")
		else:
			currentState=states.DRINKING 
			waterPath()
			print("HOm Now")
	else:
		print("cetinue")
	
	stateControlling()


func _on_food_checker_area_entered(area: Area2D) -> void:
	foodRepository=area.get_parent()


func _on_food_checker_area_exited(area: Area2D) -> void:
	if(foodRepository==area.get_parent()):
		foodRepository=null
		
func _on_water_checker_area_entered(area: Area2D) -> void:
	waterRepository=area.get_parent()


func _on_water_checker_area_exited(area: Area2D) -> void:
	if(waterRepository==area.get_parent()):
		waterRepository=null

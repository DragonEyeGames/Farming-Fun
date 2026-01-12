extends CharacterBody2D
class_name Player
var state="idle"
var direction="down"
@export var canMove:=true
var interacting:=[]
var sprite: AnimatedSprite2D
var effects
var pickedUp:=false
@export var carrot: PackedScene
@export var raddish: PackedScene
@export var potato: PackedScene
@export var onion: PackedScene
var selectedSeed=""
@export var busy:=false

func _ready() -> void:
	sprite = $Sprite
	effects=$PlantEffects
	GameManager.player=self
	$plantChecker.visible=true
	$Items.visible=true

func _process(_delta: float) -> void:
		
	#if(Input.is_action_just_pressed("Interact")):
	velocity = (Input.get_vector("Left", "Right", "Up", "Down")).normalized()*80
	if(canMove):
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
		move_and_slide()
		
	if(velocity.x<0):
		$Items.scale.x=-1
	elif(velocity.x>0):
		$Items.scale.x=1
		
	if(velocity!=Vector2.ZERO):
		state="walk"
	else:
		state="idle"
		
	if((GameManager.itemSelected("seeds") and canMove) or selectedSeed!=""):
		for child in $plantChecker.get_children():
			child.visible=false
		var selectedBit
		if(direction=="up"):
			selectedBit=$plantChecker/up
		if(direction=="down"):
			selectedBit=$plantChecker/down
		if(direction=="side"):
			if(sprite.flip_h):
				selectedBit=$"plantChecker/left-side"
			else:
				selectedBit=$"plantChecker/right-side"
		selectedBit.visible=true
		var cell := GameManager.plantable.local_to_map(
		GameManager.plantable.to_local(selectedBit.global_position)
		)
		var tile := GameManager.plantable.get_cell_source_id(cell)
		if(tile==0):
			selectedBit.get_child(0).color=Color.WEB_GREEN
		else:
			selectedBit.get_child(0).color=Color.RED
		selectedBit.modulate.a=.6
	elif(not GameManager.itemSelected("seeds")):
		for child in $plantChecker.get_children():
			child.visible=false
		
	if(GameManager.itemSelected("watering")):
		for child in $waterChecker.get_children():
			child.visible=false
		var selectedBit
		if(direction=="up"):
			selectedBit=$waterChecker/Up
		if(direction=="down"):
			selectedBit=$waterChecker/Down
		if(direction=="side"):
			if(sprite.flip_h):
				selectedBit=$waterChecker/Side2
			else:
				selectedBit=$waterChecker/Side
		selectedBit.visible=true
	else:
		for child in $waterChecker.get_children():
			child.visible=false
		
	var animation = state + "-" + direction
	if(GameManager.selectedItem!=null and GameManager.selectedItem.item!=null and ("walk" in sprite.animation or "idle" in sprite.animation)):
		pickedUp=true
		for child in $Items.get_children():
			child.visible=(child.name==str(GameManager.inventoryItem.keys()[GameManager.selectedItem.item]))
	else:
		pickedUp=false
		for child in $Items.get_children():
			child.visible=false
	if(pickedUp):
		animation = "picked-" + animation
	if(canMove):
		if(sprite.animation!=animation):
			sprite.play(animation)
	if(Input.is_action_just_pressed("Interact") and len(interacting)>=1):
		interacting[0].interact()
		interacting.remove_at(0)
		canMove=false
		sprite.play("pickup-" + direction)
	elif(Input.is_action_just_pressed("Interact") and GameManager.selectedItem!=null and canMove):
		if(GameManager.itemSelected("seeds") and GameManager.plantable!=null):
			var backupDirection=direction
			if(sprite.flip_h and direction=="side"):
				backupDirection="left-side"
			elif(direction=="side"):
				backupDirection="right-side"
			var cell := GameManager.plantable.local_to_map(
			GameManager.plantable.to_local($plantChecker.get_node(backupDirection).global_position)
			)
			var tile := GameManager.plantable.get_cell_source_id(cell)
			selectedSeed=GameManager.inventoryItem.keys()[GameManager.selectedItem.item]
			if(tile==0):
				GameManager.selectedItem.use()
				canMove=false
				sprite.play("plant-" + direction)
				effects.get_node(direction).play("plant-" + direction)
				if(sprite.flip_h):
					effects.scale.x=-1
				else:
					effects.scale.x=1
		if(GameManager.itemSelected("watering") and GameManager.plantable!=null and not busy and canMove and GameManager.selectedItem.amount>0 and not $ActionAnimator.is_playing()):
			busy=true
			var backupDirection=direction
			if(backupDirection=="side"):
				if(sprite.flip_h):
					backupDirection="Left"
				else:
					backupDirection="Right"
			canMove=false
			$ActionAnimator.play("water" + backupDirection)
			# Find if any plants are colliding
			#Add to backup list
			#Make it so can't move
			#Play animation
			#Water plants in list (make them grow one tick for now)
			GameManager.selectedItem.use()
			await get_tree().create_timer(.1).timeout
			busy=false


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
	if("plant" in sprite.animation):
		var plant
		if(selectedSeed=="Carrot_Seeds"):
			plant=carrot.instantiate()
		elif(selectedSeed=="Potato_Seeds"):
			plant=potato.instantiate()
		elif(selectedSeed=="Raddish_Seeds"):
			plant=raddish.instantiate()
		elif(selectedSeed=="Onion_Seeds"):
			plant=onion.instantiate()
		for child in $plantChecker.get_children():
			if(child.visible):
				plant.global_position=child.global_position
				GameManager.ySort.add_child(plant)
				plant.global_position=child.global_position
				break
		canMove=true
		selectedSeed=""
	if("water" in sprite.animation):
		canMove=true
		for child in $waterChecker.get_children():
			if(child.visible):
				child.growPlants()
				break


func _on_down_animation_finished() -> void:
	$PlantEffects/down.play("reset")


func _on_up_animation_finished() -> void:
	$PlantEffects/up.play("reset")


func _on_side_animation_finished() -> void:
	$PlantEffects/side.play("reset")


func _side_water() -> void:
	$WaterEffects/side.play("reset")


func _water_down() -> void:
	$WaterEffects/down.play("reset")


func _water_up() -> void:
	$WaterEffects/up.play("reset")

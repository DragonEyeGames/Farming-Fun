extends CharacterBody2D
class_name Player
var state="idle"
var direction="down"
@export var canMove:=true
@export var speed=100
var interacting:=[]
#var sprite: AnimatedSprite2D
var newSprite: AnimatedSprite2D
var effects
var pickedUp:=false
@export var carrot: PackedScene
@export var raddish: PackedScene
@export var potato: PackedScene
@export var onion: PackedScene
var selectedSeed=""
@export var busy:=false
var sleeping:=false

func _ready() -> void:
	#sprite = $Sprite
	newSprite=$NewSprite
	effects=$PlantEffects
	GameManager.player=self
	$plantChecker.visible=true
	$Items.visible=true

func _process(_delta: float) -> void:
	$Items.visible=canMove
	if(Input.is_action_just_pressed("Inventory") and (canMove or $Inventory.visible)):
		$Inventory.visible=!$Inventory.visible
		GameManager.hud.visible=!$Inventory.visible
		if($Inventory.visible and canMove):
			canMove=false
		else:
			canMove=true
	if(sleeping):
		canMove=false
	#if(Input.is_action_just_pressed("Interact")):
	velocity = (Input.get_vector("Left", "Right", "Up", "Down")).normalized()*speed
	if(canMove):
		if(velocity.x<0):
			direction="side"
			newSprite.flip_h=true
		elif(velocity.x>0):
			newSprite.flip_h=false
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

	if(Input.is_action_just_pressed("Interact") and direction=="down" and len(interacting)>=1):
		interacting[0].interact()
		interacting.remove_at(0)
		canMove=false
		newSprite.play("pickup-down")
	elif(Input.is_action_just_pressed("Interact") and direction=="up" and len(interacting)>=1):
		interacting[0].interact()
		interacting.remove_at(0)
		canMove=false
		newSprite.play("pickup-up")
	if(canMove):
		animate()
	
	if((GameManager.itemSelected("seeds") and canMove) or selectedSeed!=""):
		for child in $plantChecker.get_children():
			child.visible=false
		var selectedBit
		if(direction=="up"):
			selectedBit=$plantChecker/up
		if(direction=="down"):
			selectedBit=$plantChecker/down
		if(direction=="side"):
			if(newSprite.flip_h):
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
			if(newSprite.flip_h):
				selectedBit=$waterChecker/Side2
			else:
				selectedBit=$waterChecker/Side
		selectedBit.visible=true
	else:
		for child in $waterChecker.get_children():
			child.visible=false
		
	var animation = state + "-" + direction
	if(GameManager.selectedItem!=null and GameManager.selectedItem.item!=null and ("walk" in newSprite.animation or "idle" in newSprite.animation)):
		pickedUp=true
		for child in $Items.get_children():
			child.visible=(child.name==str(GameManager.inventoryItem.keys()[GameManager.selectedItem.item]))
	else:
		pickedUp=false
		for child in $Items.get_children():
			child.visible=false
	if(pickedUp):
		animation = "picked-" + animation
	#if(Input.is_action_just_pressed("Interact") and len(interacting)>=1):
	#	interacting[0].interact()
	#	interacting.remove_at(0)
	#	canMove=false
	#	sprite.play("pickup-" + direction)
	if(Input.is_action_just_pressed("Interact") and direction=="down" and len(interacting)>=1):
		interacting[0].interact()
		interacting.remove_at(0)
		canMove=false
		newSprite.play("pickup-down")
		return
	elif(Input.is_action_just_pressed("Interact") and direction=="up" and len(interacting)>=1):
		interacting[0].interact()
		interacting.remove_at(0)
		canMove=false
		newSprite.play("pickup-up")
		return
	elif(Input.is_action_just_pressed("Interact") and direction=="side" and len(interacting)>=1):
		interacting[0].interact()
		interacting.remove_at(0)
		canMove=false
		newSprite.play("pickup-side")
		return
		
	if(Input.is_action_just_pressed("Interact") and GameManager.selectedItem!=null and canMove):
		if(GameManager.itemSelected("seeds") and GameManager.plantable!=null and GameManager.energy>0):
			var backupDirection=direction
			$plantChecker.modulate.a=0
			GameManager.energy-=1
			if(newSprite.flip_h and direction=="side"):
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
				newSprite.play("plant-" + direction)
				effects.get_node(direction).play("plant-" + direction)
				if(newSprite.flip_h):
					effects.scale.x=-1
				else:
					effects.scale.x=1
		if(GameManager.itemSelected("watering") and GameManager.plantable!=null and not busy and canMove and GameManager.selectedItem.amount>0 and not $ActionAnimator.is_playing() and GameManager.energy>0):
			busy=true
			GameManager.energy-=1
			var backupDirection=direction
			if(backupDirection=="side"):
				if(newSprite.flip_h):
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


func _on_down_animation_finished() -> void:
	$PlantEffects/down.play("reset")
	$plantChecker.modulate.a=1


func _on_up_animation_finished() -> void:
	$PlantEffects/up.play("reset")
	$plantChecker.modulate.a=1


func _on_side_animation_finished() -> void:
	$PlantEffects/side.play("reset")
	$plantChecker.modulate.a=1


func _side_water() -> void:
	$WaterEffects/side.play("reset")


func _water_down() -> void:
	$WaterEffects/down.play("reset")


func _water_up() -> void:
	$WaterEffects/up.play("reset")


func _on_new_sprite_animation_finished() -> void:
	canMove=true
	if("plant" in newSprite.animation):
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
	if("water" in newSprite.animation):
		canMove=true
		for child in $waterChecker.get_children():
			if(child.visible):
				child.growPlants()
				break

func animate():
		
	if(pickedUp and direction=="down" and state=="idle"):
		newSprite.play("picked-idle-down")
	elif(pickedUp and direction=="down" and state=="walk"):
		newSprite.play("picked-walk-down")
	elif(direction=="down" and state=="walk"):
		newSprite.play("walk-down")
	elif(direction=="down" and state=="idle"):
		newSprite.play("idle-down")
		
	if(pickedUp and direction=="up" and state=="idle"):
		newSprite.play("picked-idle-up")
	elif(pickedUp and direction=="up" and state=="walk"):
		newSprite.play("picked-walk-up")
	elif(direction=="up" and state=="walk"):
		newSprite.play("walk-up")
	elif(direction=="up" and state=="idle"):
		newSprite.play("idle-up")
	
	if(pickedUp and direction=="side" and state=="idle"):
		newSprite.play("picked-idle-side")
	elif(pickedUp and direction=="side" and state=="walk"):
		newSprite.play("picked-walk-side")
	elif(direction=="side" and state=="idle"):
		newSprite.play("idle-side")
	elif(direction=="side" and state=="walk"):
		newSprite.play("walk-side")

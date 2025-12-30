extends CharacterBody2D

var state="idle"
var direction="down"
var canMove:=true
var interacting:=[]
var sprite: AnimatedSprite2D
var effects
var pickedUp:=false
@export var carrot: PackedScene
@export var raddish: PackedScene
@export var potato: PackedScene
@export var onion: PackedScene
var selectedSeed

func _ready() -> void:
	sprite = $Sprite
	effects=$Effects
	GameManager.player=self

func _process(_delta: float) -> void:
	if(not canMove):
		return
		
		
	#if(Input.is_action_just_pressed("Interact")):
	velocity = (Input.get_vector("Left", "Right", "Up", "Down")).normalized()*80
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
	if(velocity!=Vector2.ZERO):
		state="walk"
	else:
		state="idle"
		
	if("seeds" in str(GameManager.selectedItem).to_lower()):
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
	else:
		for child in $plantChecker.get_children():
			child.visible=false
		
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
	elif(Input.is_action_just_pressed("Interact") and GameManager.selectedItem!=null):
		if("seeds" in str(GameManager.selectedItem).to_lower() and GameManager.plantable!=null):
			var backupDirection=direction
			if(sprite.flip_h and direction=="side"):
				backupDirection="left-side"
			elif(direction=="side"):
				backupDirection="right-side"
			var cell := GameManager.plantable.local_to_map(
			GameManager.plantable.to_local($plantChecker.get_node(backupDirection).global_position)
			)
			var tile := GameManager.plantable.get_cell_source_id(cell)
			var keys := GameManager.playerInventory.keys()
			var selectedItems = keys[GameManager.playerSelected]
			selectedSeed=GameManager.playerSelected
			if(tile==0):
				GameManager.removeItem(selectedItems, 1)
				canMove=false
				sprite.play("plant-" + direction)
				effects.get_node(direction).play("plant-" + direction)
				if(sprite.flip_h):
					effects.scale.x=-1
				else:
					effects.scale.x=1


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
		var backupDirection=direction
		if(sprite.flip_h and direction=="side"):
			backupDirection="left-side"
		elif(direction=="side"):
			backupDirection="right-side"
		var plant
		if(GameManager.inventoryItem.keys()[selectedSeed]=="Carrot"):
			plant=carrot.instantiate()
		elif(GameManager.inventoryItem.keys()[selectedSeed]=="Potato"):
			plant=potato.instantiate()
		elif(GameManager.inventoryItem.keys()[selectedSeed]=="Raddish"):
			plant=raddish.instantiate()
		elif(GameManager.inventoryItem.keys()[selectedSeed]=="Onion"):
			plant=onion.instantiate()
		plant.global_position=$plantChecker.get_node(backupDirection).global_position
		GameManager.ySort.add_child(plant)
		plant.global_position=$plantChecker.get_node(backupDirection).global_position
		canMove=true


func _on_down_animation_finished() -> void:
	$Effects/down.play("reset")


func _on_up_animation_finished() -> void:
	$Effects/up.play("reset")


func _on_side_animation_finished() -> void:
	$Effects/side.play("reset")

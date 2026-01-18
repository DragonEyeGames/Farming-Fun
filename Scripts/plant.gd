extends Node2D

var state:=0
@export var animations : Array[Sprite2D]
var picked:=false
var playerEntered:=false
var animationsBackup
@export var type: GameManager.inventoryItem

func _ready() -> void:
	for child in $Sprites.get_children():
		child.visible=false
	animations[state].visible=true
	await get_tree().process_frame
	if(state>len(animations)-1):
		state=len(animations)-1
	animations[state].visible=true

func tick() -> void:
	for child in $Sprites.get_children():
		child.visible=false
	if(picked):
		return
	state+=1
	if(state+2>len(animations)):
		state=len(animations)-2
	animations[state].visible=true

func _player_entered(body: Node2D) -> void:
	if(state==len(animations)-2):
		body.interacting.append(self)


func _player_exited(body: Node2D) -> void:
	if(state==len(animations)-2 and self in body.interacting):
		body.interacting.erase(self)
		
func interact():
	picked=true
	for child in $Sprites.get_children():
		child.visible=false
	state=len(animations)-1
	for child in $Sprites.get_children():
		child.visible=false
	animations[state].visible=true
	GameManager.addItem(type, 1)
	z_index-=1
	
func wateringHover():
	$AnimationPlayer.play("outline")
	
func wateringExit():
	$AnimationPlayer.play("normal")

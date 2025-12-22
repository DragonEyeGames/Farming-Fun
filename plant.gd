extends AnimatedSprite2D

var state:=0
@export var animations : Array[String] = ["planted", "stage1", "ready", "empty"]
var picked:=false
var playerEntered:=false
var animationsBackup
@export var type: GameManager.inventoryItem

func _ready() -> void:
	state+=4
	animation=animations[state]
	await get_tree().process_frame
	if(state>len(animations)-1):
		state=len(animations)-1
	animation=animations[state]

func tick() -> void:
	if(picked):
		return
	state+=1
	if(state+2>len(animations)):
		state=len(animations)-2
	animation=animations[state]

func _player_entered(body: Node2D) -> void:
	if(state==len(animations)-2):
		body.interacting.append(self)


func _player_exited(body: Node2D) -> void:
	if(state==len(animations)-2 and self in body.interacting):
		body.interacting.erase(self)
		
func interact():
	picked=true
	animation="empty"
	state=len(animations)-1
	GameManager.addItem(type, 1)
	print(type)

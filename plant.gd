extends AnimatedSprite2D

var state:=0
@export var animations : Array[String] = ["planted", "stage1", "ready", "empty"]
var picked:=false
var playerEntered:=false

func _ready() -> void:
	animations.append("empty")
	animation=animations[state]
	await get_tree().process_frame
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
		body.interacting=self


func _player_exited(body: Node2D) -> void:
	if(state==len(animations)-2 and body.interacting==self):
		body.interacting=null
		
func interact():
	picked=true
	animation="empty"

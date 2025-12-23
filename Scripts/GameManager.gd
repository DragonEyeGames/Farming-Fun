extends Node

var time:= 0.0

var hud
var player

enum inventoryItem {
	Carrot,
	Raddish,
	Onion,
	Potato,
	Carrot_Seeds,
	Raddish_Seeds,
	Onion_Seeds,
	Potato_Seeds
}

var playerInventory: Dictionary[inventoryItem, int] = {}
var playerSelected = null

func addItem(item, count):
	if(playerInventory.has(item)):
		playerInventory[item]+=count
	else:
		playerInventory[item]=count
		
func _process(_delta: float) -> void:
	for i in range(0, 10):
		if(Input.is_action_just_pressed(str(i+1))):
			if(playerSelected!=i):
				playerSelected=i
			else:
				playerSelected=null

extends Node

var time:= 0.0

var hud
var player

var plantable: TileMapLayer

var playerMoney:=100

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
var selectedItem

func removeItem(item, count := 1) -> void:
	if not playerInventory.has(item):
		return

	playerInventory[item] -= count

	if playerInventory[item] <= 0:
		playerInventory.erase(item)
		
func _process(_delta: float) -> void:
	for i in range(0, 10):
		if(Input.is_action_just_pressed(str(i+1))):
			if(playerSelected!=i):
				playerSelected=i
			else:
				playerSelected=null
	#The code below prints the name of the currently selected item in the inventoryqawd
	if(playerSelected!=null):
		var keys := playerInventory.keys()
		if playerSelected < keys.size():
			var selectedItems = keys[playerSelected]
			selectedItem = (inventoryItem.keys()[selectedItems])
		else:
			selectedItem=null
	else:
		selectedItem=null

extends Node

var time:= 0.0

enum inventoryItem {
	Carrot,
	Raddish,
	Onion,
	Potato,
}

var playerInventory: Dictionary[inventoryItem, int] = {}
var playerSelected: inventoryItem

func addItem(item, count):
	if(playerInventory.has(item)):
		playerInventory[item]+=count
	else:
		playerInventory[item]=count

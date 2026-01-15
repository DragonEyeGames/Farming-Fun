extends Node

var time:= 0.0
var day:=1
var lastRenderedDay:=1

var hud
var player

var plantable: TileMapLayer

var playerMoney:=100

var ySort

enum inventoryItem {
	Carrot,
	Raddish,
	Onion,
	Potato,
	Carrot_Seeds,
	Raddish_Seeds,
	Onion_Seeds,
	Potato_Seeds,
	Watering_Can
}

const sellValue := {
	inventoryItem.Carrot: 12,
	inventoryItem.Raddish: 20,
	inventoryItem.Onion: 10,
	inventoryItem.Potato: 24,

	inventoryItem.Carrot_Seeds: 2,
	inventoryItem.Raddish_Seeds: 3,
	inventoryItem.Onion_Seeds: 2,
	inventoryItem.Potato_Seeds: 4,
}

#items that are limited in use.  In style; Item: Max# uses
const limited := {
	inventoryItem.Watering_Can: 10
}



var playerInventory:= []
var playerSelected = null
var selectedItem

func _ready() -> void:
	if(len(playerInventory)<=0):
		for i in 10:
			playerInventory.append(InventorySlot.new())
	await get_tree().create_timer(.1).timeout
	addItem(inventoryItem.Watering_Can, 1)
	addItem(inventoryItem.Potato, 1)
	addItem(inventoryItem.Carrot, 1)
	addItem(inventoryItem.Onion, 1)
	addItem(inventoryItem.Raddish, 1)

func addItem(item: inventoryItem, amount := 1):
	for slot in playerInventory:
		if slot.item == item and slot.amount > 0:
			if(not item in limited):
				slot.amount += amount
			else:
				slot.amount+=limited[item]
			return true

	for slot in playerInventory:
		if slot.is_empty():
			slot.item = item
			if(not item in limited):
				slot.amount = amount
			else:
				slot.amount=limited[item]
			return true

	return false # inventory full

func removeItem(item: inventoryItem, amount := 1) -> bool:
	for slot in playerInventory:
		if slot.item == item:
			slot.amount -= amount
			if slot.amount <= 0:
				if(not item in limited):
					slot.item = null
				slot.amount = 0
			return true
	return false
		
func _process(_delta: float) -> void:
	for i in range(0, 10):
		if(Input.is_action_just_pressed(str(i+1))):
			if(playerSelected!=i):
				playerSelected=i
			else:
				playerSelected=null
	#The code below prints the name of the currently selected item in the inventoryqawd
	if(playerSelected!=null):
		selectedItem = (playerInventory[playerSelected])
	else:
		selectedItem=null

func itemSelected(item):
	if(selectedItem!=null and selectedItem.item!=null):
		return(item.to_lower() in inventoryItem.keys()[selectedItem.item].to_lower())
	else:
		return false

func inventoryHas(item):
	var itemStr=""
	for invItem in playerInventory:
		if(invItem.item!=null):
			print(inventoryItem.keys()[invItem.item])
			itemStr=inventoryItem.keys()[invItem.item]
	if(itemStr!="" and item.to_lower() in itemStr.to_lower()):
		print("true dat")
		return true
	else:
		return false

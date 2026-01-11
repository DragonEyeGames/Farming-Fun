extends Node

var time:= 0.0

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



var playerInventory: Array[InventorySlot] = []
var playerSelected = null
var selectedItem

func _ready() -> void:
	if(len(playerInventory)<=0):
		for i in 10:
			playerInventory.append(InventorySlot.new())
	await get_tree().create_timer(.1).timeout
	addItem(inventoryItem.Watering_Can, 1)

func addItem(item: inventoryItem, amount := 1):
	for slot in playerInventory:
		if slot.item == item and slot.amount > 0:
			slot.amount += amount
			return true

	for slot in playerInventory:
		if slot.is_empty():
			slot.item = item
			slot.amount = amount
			return true

	return false # inventory full

func removeItem(item: inventoryItem, amount := 1) -> bool:
	for slot in playerInventory:
		if slot.item == item:
			slot.amount -= amount
			if slot.amount <= 0:
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

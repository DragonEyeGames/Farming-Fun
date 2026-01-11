extends Control

@export var index:=1
@export var selectable:=true
@export var shopSlot:=false
var itemName=""
var selected=false

func _ready() -> void:
	await get_tree().process_frame
	$RichTextLabel.text=str(index+1)

func _process(_delta: float) -> void:
	itemName=""
	$InventoryOutline.visible=GameManager.playerSelected==index and selectable
	var keys := GameManager.playerInventory.keys()
	
	for child in $Items.get_children():
			child.visible=false
	
	if index < keys.size():
		var item = keys[index]
		if GameManager.playerInventory[item] > 0:
			itemName = GameManager.inventoryItem.keys()[item]
			$Items.get_node(itemName).visible = true
			var count := GameManager.playerInventory[item]
			$Value.text = str(count)
			if(selected and shopSlot and Input.is_action_just_pressed("Interact")):
				if(item in GameManager.sellValue):
					GameManager.removeItem(item, 1)
					GameManager.playerMoney+=GameManager.sellValue[GameManager.inventoryItem[itemName]]
	else:
		$Value.text=""
		$Popup.visible=false
	if(itemName!=""):
		$Popup/Title.text=itemName
		$Popup/Title.text=$Popup/Title.text.replace("_", " ")
		if(GameManager.inventoryItem[itemName] in GameManager.sellValue):
			$Popup/SellPrice.text="$" + str(GameManager.sellValue[GameManager.inventoryItem[itemName]])
		else:
			$Popup/SellPrice.text=""
		


func _on_color_rect_mouse_entered() -> void:
	if(itemName!="" and shopSlot):
		$Popup.visible=true
		$Popup/Title.text=itemName
		$Popup/Title.text=$Popup/Title.text.replace("_", " ")
		if(GameManager.inventoryItem[itemName] in GameManager.sellValue):
			$Popup/SellPrice.text="$" + str(GameManager.sellValue[GameManager.inventoryItem[itemName]])
		else:
			$Popup/SellPrice.text=""
		selected=true

func _on_color_rect_mouse_exited() -> void:
	$Popup.visible=false
	selected=false

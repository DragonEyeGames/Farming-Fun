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
	
	for child in $Items.get_children():
		child.visible=false
	
	var item = GameManager.playerInventory[index]
	if item.amount > 0:
		var itemIndex = (item.item)
		$Items.get_node(GameManager.inventoryItem.keys()[itemIndex]).visible = true
		var count = item.amount
		$Value.text = str(count)
		if(selected and shopSlot and Input.is_action_just_pressed("Interact")):
			if(item.item in GameManager.sellValue):
				GameManager.removeItem(item.item, 1)
				GameManager.playerMoney+=GameManager.sellValue[GameManager.inventoryItem[itemName]]
	else:
		$Value.text=""
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

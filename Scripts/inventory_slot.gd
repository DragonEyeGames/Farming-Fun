extends Control

@export var index:=1
@export var selectable:=true
@export var shopSlot:=false
@export var popable:=false
@export var organizable:=false
var dragging=false
var itemName=""
var selected=false
var mouseEntered:=false

func _ready() -> void:
	await get_tree().process_frame
	$RichTextLabel.text=str(index+1)
	if(shopSlot):
		popable=true

func _process(_delta: float) -> void:
	if(itemName!="" and $Popup.visible and organizable and not dragging and Input.is_action_just_pressed("Click") and GameManager.dragging==-1):
		dragging=true
		GameManager.dragging=index
	if(not dragging and GameManager.dragging!=-1 and Input.is_action_just_pressed("Click") and mouseEntered):
		var backup=GameManager.playerInventory[index]
		GameManager.playerInventory[index]=GameManager.playerInventory[GameManager.dragging]
		GameManager.playerInventory[GameManager.dragging]=backup
		GameManager.dragging=-1
	if(dragging and GameManager.dragging==-1):
		dragging=false
		$Items.position=Vector2(47, 48)
		$Items.z_index=0
	if(dragging):
		$Items.global_position=get_global_mouse_position()
		$Items.z_index=1
	if($Popup.visible and GameManager.dragging!=-1):
		$Popup.visible=false
	$InventoryOutline.visible=GameManager.playerSelected==index and selectable
	
	for child in $Items.get_children():
		child.visible=false
	
	var item = GameManager.playerInventory[index] as InventorySlot
	if(item.item!=null):
		itemName=GameManager.inventoryItem.keys()[item.item]
	else:
		itemName=""
		if($Popup.visible):
			$Popup.visible=false
	if (item.amount > 0 or item.item in GameManager.limited):
		var itemIndex = (item.item)
		$Items.get_node(GameManager.inventoryItem.keys()[itemIndex]).visible = true
		var count = item.amount
		if(not item.item in GameManager.limited):
			$Value.text = str(count)
		else:
			$Value.text = ""
			$Items.get_node(GameManager.inventoryItem.keys()[itemIndex]).get_child(0).value=item.amount
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
		$Popup/Description.text=GameManager.description[GameManager.inventoryItem[itemName]]
		


func _on_color_rect_mouse_entered() -> void:
	mouseEntered=true
	if(itemName!="" and popable):
		$Popup.visible=true
		$Popup/Title.text=itemName
		$Popup/Title.text=$Popup/Title.text.replace("_", " ")
		if(GameManager.inventoryItem[itemName] in GameManager.sellValue):
			$Popup/SellPrice.text="$" + str(GameManager.sellValue[GameManager.inventoryItem[itemName]])
		else:
			$Popup/SellPrice.text=""
		selected=true

func _on_color_rect_mouse_exited() -> void:
	mouseEntered=false
	$Popup.visible=false
	selected=false

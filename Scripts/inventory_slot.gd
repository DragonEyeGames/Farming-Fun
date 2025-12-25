extends Control

@export var index:=1
@export var selectable:=true

func _ready() -> void:
	await get_tree().process_frame
	$RichTextLabel.text=str(index+1)

func _process(_delta: float) -> void:
	$InventoryOutline.visible=GameManager.playerSelected==index and selectable
	var keys := GameManager.playerInventory.keys()
	
	for child in $Items.get_children():
			child.visible=false
	
	if index < keys.size():
		var item = keys[index]
		if GameManager.playerInventory[item] > 0:
			var itemName = GameManager.inventoryItem.keys()[item]
			$Items.get_node(itemName).visible = true
			var count := GameManager.playerInventory[item]
			$Value.text = str(count)
	else:
		$Value.text=""
		
		

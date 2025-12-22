extends Control

@export var index:=1

func _ready() -> void:
	await get_tree().process_frame
	$RichTextLabel.text=str(index+1)

func _process(_delta: float) -> void:
	$InventoryOutline.visible=GameManager.playerSelected==index
	var keys := GameManager.playerInventory.keys()

	if index < keys.size():
		var item = keys[index]
		if GameManager.playerInventory[item] > 0:
			var itemName = GameManager.inventoryItem.keys()[item]
			get_node(itemName).visible = true
			var count := GameManager.playerInventory[item]
			$Value.text = str(count)
	else:
		$Value.text=""
		
		

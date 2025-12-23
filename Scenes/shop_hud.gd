extends CanvasLayer

func _process(_delta: float) -> void:
	$"Money Holder/RichTextLabel".text=str(GameManager.playerMoney)


func _on_item_pressed(id) -> void:
	var caller = $ScrollContainer/VBoxContainer.get_child(id)
	GameManager.playerMoney-=caller.money
	GameManager.addItem(caller.item, 1)

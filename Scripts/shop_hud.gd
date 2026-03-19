extends CanvasLayer

func _process(_delta: float) -> void:
	$"Money Holder/RichTextLabel".text=str(GameManager.playerMoney)


func _on_item_pressed(id) -> void:
	var caller = $ScrollContainer/VBoxContainer.get_child(id)
	if(GameManager.playerMoney-caller.cost>=0):
		caller.success()
		GameManager.playerMoney-=caller.cost
		GameManager.addItem(caller.item, 1)
	else:
		caller.fail()


func _on_close_mouse_entered() -> void:
	var tween=create_tween()
	tween.tween_property($Close, "scale", Vector2(.72, .72), .1)


func _on_close_mouse_exited() -> void:
	var tween=create_tween()
	tween.tween_property($Close, "scale", Vector2(.64, .64), .1)

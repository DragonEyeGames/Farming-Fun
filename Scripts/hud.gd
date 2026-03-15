extends CanvasLayer

func _ready() -> void:
	var index=0
	GameManager.hud=self
	for child in $HBoxContainer.get_children():
		child.index=index
		index+=1

func _process(_delta: float) -> void:
	$Energy/ProgressBar.value=remap(GameManager.energy, 0, 40, 8.1, 36.6)
	$Water/ProgressBar.value=remap(GameManager.playerInventory[0].amount, 0, 20, 3.5, 17.5)
	if((GameManager.selectedItem!=null and GameManager.selectedItem.item!=null and str(GameManager.inventoryItem.keys()[GameManager.selectedItem.item])=="Watering_Can")):
		if($Water.modulate.a==0):
			var tween=create_tween()
			tween.tween_property($Water, "modulate:a", 1, .1)
	elif($Water.modulate.a==1):
			var tween=create_tween()
			tween.tween_property($Water, "modulate:a", 0, .1)
	var total_minutes := int(GameManager.time * 24 * 60)
	var hours := int(total_minutes / 60.0)
	var minutes := total_minutes % 60
	var time_24h := "%02d:%02d" % [hours, minutes]
	$TimeHolder/RichTextLabel.text=str(time_24h)
	$"Money Holder/RichTextLabel".text=str(GameManager.playerMoney)
	$TimeHolder/Day.text="Day: " + str(GameManager.day)

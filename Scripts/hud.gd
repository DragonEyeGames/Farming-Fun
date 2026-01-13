extends CanvasLayer

func _ready() -> void:
	var index=0
	GameManager.hud=self
	for child in $HBoxContainer.get_children():
		child.index=index
		index+=1

func _process(_delta: float) -> void:
	var total_minutes := int(GameManager.time * 24 * 60)
	var hours := int(total_minutes / 60.0)
	var minutes := total_minutes % 60
	var time_24h := "%02d:%02d" % [hours, minutes]
	$TimeHolder/RichTextLabel.text=str(time_24h)
	$"Money Holder/RichTextLabel".text=str(GameManager.playerMoney)
	$TimeHolder/Day.text="Day: " + str(GameManager.day)

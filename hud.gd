extends CanvasLayer

func _process(_delta: float) -> void:
	var total_minutes := int(GameManager.time * 24 * 60)
	var hours := total_minutes / 60
	var minutes := total_minutes % 60
	var time_24h := "%02d:%02d" % [hours, minutes]
	$TimeHolder/RichTextLabel.text=str(time_24h)

extends CanvasModulate

func _ready() -> void:
	cycle()
	
func cycle():
	var tween=create_tween()
	tween.tween_property(self, "color", Color(.2, .2, .2), 2)
	await get_tree().create_timer(10).timeout
	var tween2=create_tween()
	tween2.tween_property(self, "color", Color.WHITE, 2)
	await get_tree().create_timer(5).timeout
	$"../SignalBus".emit_signal("tick")
	await get_tree().create_timer(5).timeout
	cycle()

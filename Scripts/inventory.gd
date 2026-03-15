extends CanvasLayer


func _on_button_pressed() -> void:
	visible=false
	get_parent().canMove=true
	GameManager.hud.visible=true

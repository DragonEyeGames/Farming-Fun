extends Control

var playing: bool = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameManager.muted=true
	await get_tree().create_timer(12.5).timeout
	playing=false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$Camera2D.global_position=get_global_mouse_position()/12
	#print(get_global_mouse_position())
	if(Input.is_action_just_pressed("Click") or Input.is_action_just_pressed("Escape") and playing):
		playing=false
		$AudioStreamPlayer.stop()
		$AnimationPlayer.play("afterAnimation")


func _on_start_mouse_entered() -> void:
	var tween=create_tween()
	tween.tween_property($CanvasLayer4/Control/Start, "scale", Vector2(.55, .55) , .2)


func _on_start_mouse_exited() -> void:
	var tween=create_tween()
	tween.tween_property($CanvasLayer4/Control/Start, "scale", Vector2(.505, .505) , .2)


func _on_start_pressed() -> void:
	var tween=create_tween()
	tween.tween_property($CanvasLayer5/ColorRect, "color:a", 1, .5)
	await tween.finished
	GameManager.muted=false
	get_tree().change_scene_to_file("res://Scenes/Main.tscn")

extends Control

var playing: bool = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameManager.muted=true
	await get_tree().process_frame
	$CanvasLayer6/Settings/VBoxContainer/Master/HSlider.value=GameManager.masterVolume
	$CanvasLayer6/Settings/VBoxContainer/Music/HSlider.value=GameManager.musicVolume
	$CanvasLayer6/Settings/VBoxContainer/SFX/HSlider.value=GameManager.sfxVolume
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


func _on_settings_mouse_entered() -> void:
	var tween=create_tween()
	tween.tween_property($CanvasLayer4/Control/Settings, "scale", Vector2(.55, .55) , .2)


func _on_settings_mouse_exited() -> void:
	var tween=create_tween()
	tween.tween_property($CanvasLayer4/Control/Settings, "scale", Vector2(.505, .505) , .2)


func _on_quit_mouse_entered() -> void:
	var tween=create_tween()
	tween.tween_property($CanvasLayer4/Control/Quit, "scale", Vector2(.55, .55) , .2)


func _on_quit_mouse_exited() -> void:
	var tween=create_tween()
	tween.tween_property($CanvasLayer4/Control/Quit, "scale", Vector2(.505, .505) , .2)
	
#Volume

func on_master_change(value: float) -> void:
	GameManager.masterVolume=value
	var multiplier=1
	if(value==-2000):
		value=-6400
	if(value<0):
		value=abs(value)
		multiplier=-1
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), sqrt(value)*multiplier)
	
func on_music_changed(value: float) -> void:
	GameManager.musicVolume=value
	var multiplier=1
	if(value==-2000):
		value=-6400
	if(value<0):
		value=abs(value)
		multiplier=-1
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), sqrt(value)*multiplier)
	
func on_sfx_change(value: float) -> void:
	GameManager.sfxVolume=value
	var multiplier=1
	if(value==-2000):
		value=-6400
	if(value<0):
		value=abs(value)
		multiplier=-1
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), sqrt(value)*multiplier)
	
func _on_settings_close_pressed() -> void:
	var volume = VolumeData.new()
	volume.master=GameManager.masterVolume
	volume.sfx=GameManager.sfxVolume
	volume.music=GameManager.musicVolume
	ResourceSaver.save(volume, "user://volume_data.tres")
	var tween=create_tween()
	tween.tween_property($CanvasLayer6/Settings, "modulate:a", 0, .2)
	await tween.finished
	$CanvasLayer6/Settings.visible=false


func _on_settings_pressed() -> void:
	$CanvasLayer6/Settings.visible=true
	var tween=create_tween()
	tween.tween_property($CanvasLayer6/Settings, "modulate:a", 1, .2)


func _on_settings_close_mouse_entered() -> void:
	var tween=create_tween()
	tween.tween_property($CanvasLayer6/Settings/SettingsClose, "scale", Vector2(1.1, 1.1) , .2)


func _on_settings_close_mouse_exited() -> void:
	var tween=create_tween()
	tween.tween_property($CanvasLayer6/Settings/SettingsClose, "scale", Vector2(1, 1) , .2)


func _on_quit_pressed() -> void:
	get_tree().quit()

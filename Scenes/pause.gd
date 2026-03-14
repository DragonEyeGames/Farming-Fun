extends CanvasLayer

var paused=false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if(Input.is_action_just_pressed("Pause")):
		print("pause")
		paused=!paused
		if(paused):
			AudioServer.set_bus_effect_enabled(1, 0, true)
			AudioServer.set_bus_effect_enabled(1, 1, true)
			get_tree().paused=true
			$Animate.play("open")
		elif(!paused):
			AudioServer.set_bus_effect_enabled(1, 0, false)
			AudioServer.set_bus_effect_enabled(1, 1, false)
			$Animate.play("close")
			await get_tree().create_timer(1).timeout
			get_tree().paused=false


func _on_resume_pressed() -> void:
	AudioServer.set_bus_effect_enabled(1, 0, false)
	AudioServer.set_bus_effect_enabled(1, 1, false)
	paused=false
	$Animate.play("close")
	await get_tree().create_timer(1).timeout
	get_tree().paused=false


func _on_settings_pressed() -> void:
	$Settings.visible=true
	var tween=create_tween()
	tween.tween_property($Settings, "modulate:a", 1, .1)
	


func _on_save_pressed() -> void:
	if(GameManager.main!=null):
		$Holder/VBoxContainer/Save/Save.text="Saving"
		$Holder/VBoxContainer/Save/Save.disabled=true
		await GameManager.main.saveGame()
		await get_tree().create_timer(.1).timeout
		$Holder/VBoxContainer/Save/Save.text="Saved"
		await get_tree().create_timer(1).timeout
		$Holder/VBoxContainer/Save/Save.disabled=false
		$Holder/VBoxContainer/Save/Save.text="Save"


func _on_exit_pressed() -> void:
	get_tree().quit()


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


func _on_settings_close_mouse_entered() -> void:
	var tween=create_tween()
	tween.tween_property($Settings/SettingsClose, "scale", Vector2(1.1, 1.1), .1)


func _on_settings_close_mouse_exited() -> void:
	var tween=create_tween()
	tween.tween_property($Settings/SettingsClose, "scale", Vector2(1, 1), .1)


func _on_settings_close_pressed() -> void:
	var tween=create_tween()
	tween.tween_property($Settings, "modulate:a", 0, .1)
	await get_tree().create_timer(.1).timeout
	await get_tree().process_frame
	$Settings.visible=false

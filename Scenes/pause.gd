extends CanvasLayer

var paused=false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if(Input.is_action_just_pressed("Pause")):
		paused=!paused
		if(paused):
			get_tree().paused=true
			$Animate.play("open")
		elif(!paused):
			$Animate.play("close")
			await get_tree().create_timer(1).timeout
			get_tree().paused=false


func _on_resume_pressed() -> void:
	paused=false
	$Animate.play("close")
	await get_tree().create_timer(1).timeout
	get_tree().paused=false


func _on_settings_pressed() -> void:
	pass # Replace with function body.


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

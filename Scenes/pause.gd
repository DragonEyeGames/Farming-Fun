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
			get_tree().paused=paused
			$Animate.play("open")
		elif(!paused):
			$Animate.play("close")
			await get_tree().create_timer(1).timeout
			get_tree().paused=paused

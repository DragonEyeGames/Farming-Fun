extends AnimatedSprite2D

var playerEntered:=false

func _ready() -> void:
	randomEvents()
	
func randomEvents():
	await get_tree().create_timer(randi_range(5, 10)).timeout
	if(randi_range(1, 2)==1 and not playerEntered):
		play("look")
	randomEvents()

func _process(_delta: float) -> void:
	if(playerEntered and Input.is_action_just_pressed("Interact")):
		GameManager.hud.visible=false
		GameManager.player.canMove=false
		GameManager.player.sprite.play("idle-up")
		$"../HUD".visible=true

func _on_animation_finished() -> void:
	play("idle")


func _on_area_2d_body_entered(_body: Node2D) -> void:
	playerEntered=true
	play("wave")


func _on_area_2d_body_exited(_body: Node2D) -> void:
	playerEntered=false

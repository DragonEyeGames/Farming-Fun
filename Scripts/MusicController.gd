extends Node

var backupMuted = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	select()
	
func select():
	var child = get_children().pick_random()
	child.play()
	
func _process(_delta: float) -> void:
	if(GameManager.muted and not backupMuted):
		backupMuted=true
		for child in get_children():
			child.stop()
	elif(backupMuted and not GameManager.muted):
		backupMuted=false
		select()

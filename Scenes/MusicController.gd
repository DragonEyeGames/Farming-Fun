extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	select()
	
func select():
	var child = get_children().pick_random()
	child.play()

extends Node2D

@export var showBar:=true

func _ready():
	for child in get_children():
		if(child.is_in_group("Limited")):
			child.get_child(0).visible=showBar

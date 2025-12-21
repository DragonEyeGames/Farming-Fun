extends Node2D

var waitTime:=0.0

func _process(delta: float) -> void:
	waitTime+=delta
	if(waitTime>=1):
		waitTime-=1
		for child in $Plants.get_children():
			child.tick()

extends CharacterBody2D

var count :=0.0
var toDisplay="right"

var interacting=null

func _process(delta: float) -> void:
	#if(Input.is_action_just_pressed("Interact")):
	count+=delta
	velocity = Input.get_vector("Left", "Right", "Up", "Down")*80
	move_and_slide()
	if(velocity.x<0):
		$Body.scale.x=-1
	elif(velocity.x>0):
		$Body.scale.x=1
		
	if(count>.14 and not velocity==Vector2.ZERO):
		count=0
		for child in $Body.get_children():
			child.animation=toDisplay
			if(child.frame>=5):
				child.frame=0
			else:
				child.frame+=1
	elif(velocity==Vector2.ZERO):
		for child in $Body.get_children():
			child.frame=0
	if(Input.is_action_just_pressed("Interact") and interacting!=null):
		interacting.interact()
		interacting=null

extends Area2D

var collidingList=[]

func _process(_delta: float) -> void:
	if(len(collidingList)>=1):
		$ColorRect.color=Color.WEB_GREEN
	else:
		$ColorRect.color=Color.RED
	$ColorRect.modulate.a=.6

func _on_area_entered(area: Area2D) -> void:
	collidingList.append(area.get_parent())


func _on_area_exited(area: Area2D) -> void:
	collidingList.erase(area.get_parent())
	
func growPlants():
	for plant in collidingList:
		plant.tick()

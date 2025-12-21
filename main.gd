extends Node2D

func _ready() -> void:
	if ResourceLoader.exists("user://farm_data.tres"):
		var data = ResourceLoader.load("user://farm_data.tres") as FarmData
		for saveable in get_tree().get_nodes_in_group("Save"):
			saveable.queue_free()
		for animal in data.animals:
			var newAnimal=animal.instantiate()
			add_child(newAnimal)
		for crop in data.crops:
			var newCrop=crop.instantiate()
			$Farm/Plants.add_child(newCrop)
			newCrop.state=data.cropStates[data.crops.find(crop)]
	for door in get_tree().get_nodes_in_group("Door"):
		door.mainScene=self
	for object in get_tree().get_nodes_in_group("Sort"):
		object.reparent($YSort)
		
func transport(file: String):
	var save = FarmData.new()
	for saveable in get_tree().get_nodes_in_group("Save"):
		if(saveable.is_in_group("Animal")):
			var animalScene = PackedScene.new()
			animalScene.pack(saveable)
			save.animals.append(animalScene)
		if(saveable.is_in_group("Crop")):
			var cropScene = PackedScene.new()
			cropScene.pack(saveable)
			save.crops.append(cropScene)
			save.cropStates.append(saveable.state)
	ResourceSaver.save(save, "user://farm_data.tres")
	get_tree().change_scene_to_file(file)

extends Node2D

@export var sky: Node2D
@export var playerNode: Node2D
@export var SignalBus: Node2D

func _ready() -> void:
	var lastRenderedDay
	if ResourceLoader.exists("user://farm_data.tres"):
		var data = ResourceLoader.load("user://farm_data.tres") as FarmData
		for saveable in get_tree().get_nodes_in_group("Save"):
			saveable.queue_free()
		for animal in data.animals:
			var newAnimal=animal.instantiate()
			add_child(newAnimal)
		for crop in data.crops:
			var newCrop=crop.instantiate()
			$YSort.add_child(newCrop)
			newCrop.state=data.cropStates[data.crops.find(crop)]
		lastRenderedDay=data.lastRendered
		GameManager.lastRenderedDay=GameManager.day
		if(lastRenderedDay<GameManager.lastRenderedDay):
			for i in GameManager.lastRenderedDay-lastRenderedDay:
				SignalBus.emit_signal("tick")
				print("ForgottenTick")
	if ResourceLoader.exists("user://world_data.tres"):
		var data = ResourceLoader.load("user://world_data.tres") as WorldData
		sky.time = data.time
	if ResourceLoader.exists("user://player_data.tres"):
		var data = ResourceLoader.load("user://player_data.tres") as PlayerData
		GameManager.playerInventory = data.inventory
		GameManager.playerMoney=data.money
		$Player.global_position=data.lastLocation
	for door in get_tree().get_nodes_in_group("Door"):
		door.mainScene=self
	for object in get_tree().get_nodes_in_group("Sort"):
		object.reparent($YSort)
		
func transport(file: String):
	GameManager.lastRenderedDay=GameManager.day
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
		save.lastRendered=GameManager.lastRenderedDay
	var world = WorldData.new()
	world.time = sky.time
	var player = PlayerData.new()
	player.inventory=GameManager.playerInventory
	player.money=GameManager.playerMoney
	player.lastLocation=playerNode.global_position
	ResourceSaver.save(save, "user://farm_data.tres")
	ResourceSaver.save(world, "user://world_data.tres")
	ResourceSaver.save(player, "user://player_data.tres")
	get_tree().change_scene_to_file(file)

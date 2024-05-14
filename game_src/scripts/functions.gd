extends Node

func load_screen_to_scene(target: String, parameters: Dictionary = {}) -> void:
	var loading_screen = preload("res://scenes/loading_screen.tscn").instantiate()
	loading_screen.nex_scene_path = target
	loading_screen.parameters = parameters # Pass params
	get_tree().current_scene.add_child(loading_screen)

var save_path = "user://global.tres"

func save_data():
	var data = Savedata.new()
	data.version = Global.version
	data.hasDash = Global.hasDash
	data.hasDoubleJump = Global.hasDoubleJump
	data.score = Global.score
	data.completion_level = Global.completion_level
	ResourceSaver.save(data, save_path)

func load_data():
	if ResourceLoader.exists(save_path):
		var data = ResourceLoader.load(save_path) as Savedata
		if data.version != Global.version:
			printerr("Loaded data not in same version ! current = " + str(Global.version) + " / loaded = " + str(data.version) )
			return null
		else:
			print("Loaded data successfuly !!!")
			return data
	else:
		return null

func is_in_completion_level(world: String, level: String) -> bool:
	if world in Global.completion_level:
		if level in Global.completion_level[world]:
			return true
	return false

func get_checkpoint(world, level):
	var world_num: = "world" + str(world)
	var level_num: = "level" + str(level)
	if is_in_completion_level(world_num, level_num):
		return Global.completion_level[world_num][level_num].checkpoint
	return null

func set_checkpoint(world, level, checkpoint):
	var world_num: = "world" + str(world)
	var level_num: = "level" + str(level)
	Global.completion_level[world_num][level_num].checkpoint = checkpoint

func get_is_level_cleared(world, level):
	var world_num: = "world" + str(world)
	var level_num: = "level" + str(level)
	if is_in_completion_level(world_num, level_num):
		return Global.completion_level[world_num][level_num].cleared
	return null

func set_level_cleared(world, level, cleared = true):
	var world_num: = "world" + str(world)
	var level_num: = "level" + str(level)
	Global.completion_level[world_num][level_num].cleared = cleared

func spawn_item_pickup(scenePathArray: Array, pos):
	var scene = load(scenePathArray.pick_random())
	var sceneInstance = scene.instantiate()
	sceneInstance.global_position = pos
	get_tree().current_scene.add_child(sceneInstance)

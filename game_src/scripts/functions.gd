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

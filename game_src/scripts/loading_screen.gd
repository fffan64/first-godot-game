extends CanvasLayer

@export_file("*.tscn") var nex_scene_path: String
@export var parameters: Dictionary # Temporarily store params to be passed to target scene

func _ready():
	ResourceLoader.load_threaded_request(nex_scene_path)
	
func _process(delta):
	if ResourceLoader.load_threaded_get_status(nex_scene_path) == ResourceLoader.THREAD_LOAD_LOADED:
		set_process(false)
		await get_tree().create_timer(1).timeout
		var new_scene: PackedScene = ResourceLoader.load_threaded_get(nex_scene_path)
		var new_node = new_scene.instantiate() # Instanciate a copy of the loaded scene
		new_node.parameters = parameters # Assign params to new scene
		var current_scene = get_tree().current_scene # Stores the currently active scene, so we can replace it later
		get_tree().root.add_child(new_node) # And adds it to the scene tree, YOU MUST ADD THE CHILD BEFORE ASSIGNING THE CURRENT SCENE TO IT
		get_tree().current_scene = new_node # Assigns our new scene as current scene
		current_scene.queue_free() # Now we can remove the original scene
		

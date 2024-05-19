extends CanvasLayer

@export_file("*.tscn") var nex_scene_path: String
@export var parameters: Dictionary # Temporarily store params to be passed to target scene
@onready var diamond = $Control/diamond

var tween

func _ready():
	tween = create_tween().set_loops()
	tween.parallel().tween_property(diamond, "rotation_degrees", 90, 1.0).as_relative()
	tween.parallel().tween_property(diamond, "scale", Vector2(0.7, 0.7), 1.0).set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_OUT)
	tween.chain().tween_property(diamond, "scale", Vector2(0.8, 0.8), 1.0)
	ResourceLoader.load_threaded_request(nex_scene_path)
	
func _process(delta):
	if ResourceLoader.load_threaded_get_status(nex_scene_path) == ResourceLoader.THREAD_LOAD_LOADED:
		#TransitionScreen.transition()
		#await TransitionScreen.on_fade_in_out_finished
		set_process(false)
		await get_tree().create_timer(1).timeout
		var new_scene: PackedScene = ResourceLoader.load_threaded_get(nex_scene_path)
		var new_node = new_scene.instantiate() # Instanciate a copy of the loaded scene
		if parameters:
			new_node.parameters = parameters # Assign params to new scene
		var current_scene = get_tree().current_scene # Stores the currently active scene, so we can replace it later
		get_tree().root.add_child(new_node) # And adds it to the scene tree, YOU MUST ADD THE CHILD BEFORE ASSIGNING THE CURRENT SCENE TO IT
		get_tree().current_scene = new_node # Assigns our new scene as current scene
		current_scene.queue_free() # Now we can remove the original scene
		

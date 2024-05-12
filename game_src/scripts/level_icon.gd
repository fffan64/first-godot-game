@tool
extends Control
class_name LevelIcon

@export var level_name := "1"
@export_file("*.tscn") var next_scene_path: String
@export var next_level_up: LevelIcon
@export var next_level_down: LevelIcon
@export var next_level_left: LevelIcon
@export var next_level_right: LevelIcon

func _ready():
	process_mode = Node.PROCESS_MODE_DISABLED
	$Label.text = "Level " + str(level_name)
	
	
	var level_dict = Global.get("Level" + str(level_name))
	if level_dict:
		if level_dict.cleared:
			var gradient_data := {
				0.0: Color.WHITE,
			}
			var gradient := Gradient.new()
			gradient.offsets = gradient_data.keys()
			gradient.colors = gradient_data.values()

			var gradient_texture := GradientTexture1D.new()
			gradient_texture.width = 64
			gradient_texture.gradient = gradient

			$TextureRect.texture = gradient_texture
		


func _process(delta):
	if Engine.is_editor_hint():
		$Label.text = "Level " + str(level_name)

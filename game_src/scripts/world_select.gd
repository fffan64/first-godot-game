extends Control

var parameters: Dictionary # This needs to be here so the scene can receive parameters

@export var music = preload("res://assets/music/Distance of Moon and Earth.ogg")

@onready var sound_valid = $SoundValid
@onready var moving_to_level_sound = $MovingToLevelSound

@onready var worlds: Array = [$"WorldMap/1", $"WorldMap/2", $"WorldMap/3", $"WorldMap/4", $"WorldMap/5"]
var current_world: int = 0
var move_tween: Tween

func _ready():
	get_tree().get_root().size_changed.connect(resize)
	if Music.stream != music:
		Music.stream = music
		Music.play()
	TransitionScreen.transition_enter()
	$PlayerIcon.global_position = worlds[current_world].global_position
	(worlds[current_world] as Control).process_mode = Node.PROCESS_MODE_INHERIT

func resize():
	$PlayerIcon.global_position = worlds[current_world].global_position
	
func _input(event):
	if move_tween and move_tween.is_running():
		return
		
	if event.is_action_pressed("move_left") and current_world > 0:
		(worlds[current_world] as Control).process_mode = Node.PROCESS_MODE_DISABLED
		current_world -= 1
		(worlds[current_world] as Control).process_mode = Node.PROCESS_MODE_INHERIT
		moving_to_level_sound.play()
		tween_icon()
		
	if event.is_action_pressed("move_right") and current_world < worlds.size() - 1:
		(worlds[current_world] as Control).process_mode = Node.PROCESS_MODE_DISABLED
		current_world += 1
		(worlds[current_world] as Control).process_mode = Node.PROCESS_MODE_INHERIT
		moving_to_level_sound.play()
		tween_icon()
	
	if event.is_action_pressed("jump"):
		if worlds[current_world].level_select_scene:
			sound_valid.play()
			TransitionScreen.transition()
			await TransitionScreen.on_fade_in_out_finished
			Global.current_world_name = worlds[current_world].name
			worlds[current_world].level_select_scene.parent_world_select = self
			get_tree().root.add_child(worlds[current_world].level_select_scene)
			get_tree().current_scene = worlds[current_world].level_select_scene
			get_tree().root.remove_child(self)
			
	if event.is_action_pressed("dash"):
		sound_valid.play()
		TransitionScreen.transition()
		await TransitionScreen.on_fade_in_out_finished
		Functions.load_screen_to_scene("res://scenes/main_menu.tscn")
			
func tween_icon():
	move_tween = get_tree().create_tween()
	move_tween.tween_property($PlayerIcon, "position", worlds[current_world].global_position, 0.5).set_trans(Tween.TRANS_SINE)
	


func _on_texture_button_pressed():
	var event = InputEventAction.new()
	event.action = "dash"
	event.pressed = true
	Input.parse_input_event(event)

extends Control
class_name LevelSelect

var parameters: Dictionary # This needs to be here so the scene can receive parameters

@onready var sound_valid = $SoundValid
@onready var current_level: LevelIcon = $"1"
var parent_world_select: Node
var move_tween: Tween

var lengthSwipe = 80
var startPosSwipe: Vector2
var curPosSwipe: Vector2
var swiping = false

var thresholdSwipe = 10

func _ready():
	$PlayerIcon.global_position = current_level.global_position
	current_level.process_mode = Node.PROCESS_MODE_INHERIT

func _process(delta):
	if Input.is_action_just_pressed("press"):
		if !swiping:
			swiping = true
			startPosSwipe = get_global_mouse_position()
	if Input.is_action_pressed("press"):
		if swiping:
			curPosSwipe = get_global_mouse_position()
			if startPosSwipe.distance_to(curPosSwipe) >= lengthSwipe:
				var bDirRight = startPosSwipe.x - curPosSwipe.x < 0
				var bDirDown = startPosSwipe.y - curPosSwipe.y < 0
				if abs(startPosSwipe.y - curPosSwipe.y) <= thresholdSwipe:
					if bDirRight:
						print_debug("Horizontal Swipe Right !")
						var event = InputEventAction.new()
						event.action = "move_right"
						event.pressed = true
						Input.parse_input_event(event)
					else:
						print_debug("Horizontal Swipe Left !")
						var event = InputEventAction.new()
						event.action = "move_left"
						event.pressed = true
						Input.parse_input_event(event)
					swiping = false
				elif abs(startPosSwipe.x - curPosSwipe.x) <= thresholdSwipe:
					if bDirDown:
						print_debug("Vertical Swipe Down !")
						var event = InputEventAction.new()
						event.action = "move_down"
						event.pressed = true
						Input.parse_input_event(event)
					else:
						print_debug("Vertical Swipe Up !")
						var event = InputEventAction.new()
						event.action = "move_up"
						event.pressed = true
						Input.parse_input_event(event)
					swiping = false
	else:
		swiping = false

func _input(event):
	if move_tween and move_tween.is_running():
		return
		
	if event.is_action_pressed("move_left") and current_level.next_level_left:
		current_level.process_mode = Node.PROCESS_MODE_DISABLED
		current_level = current_level.next_level_left
		current_level.process_mode = Node.PROCESS_MODE_INHERIT
		tween_icon()
	if event.is_action_pressed("move_right") and current_level.next_level_right:
		current_level.process_mode = Node.PROCESS_MODE_DISABLED
		current_level = current_level.next_level_right
		current_level.process_mode = Node.PROCESS_MODE_INHERIT
		tween_icon()
	if event.is_action_pressed("move_up") and current_level.next_level_up:
		current_level.process_mode = Node.PROCESS_MODE_DISABLED
		current_level = current_level.next_level_up
		current_level.process_mode = Node.PROCESS_MODE_INHERIT
		tween_icon()
	if event.is_action_pressed("move_down") and current_level.next_level_down:
		current_level.process_mode = Node.PROCESS_MODE_DISABLED
		current_level = current_level.next_level_down
		current_level.process_mode = Node.PROCESS_MODE_INHERIT
		tween_icon()

	if event.is_action_pressed("dash"):
		sound_valid.play()
		TransitionScreen.transition()
		await TransitionScreen.on_fade_in_out_finished
		get_tree().root.add_child(parent_world_select)
		get_tree().current_scene = parent_world_select
		get_tree().root.remove_child(self)
		
	if event.is_action_pressed("jump"):
		if current_level.next_scene_path:
			sound_valid.play()
			Global.current_level_name = current_level.name
			TransitionScreen.transition()
			await TransitionScreen.on_fade_in_out_finished
			Functions.load_screen_to_scene(current_level.next_scene_path)

func tween_icon():
	move_tween = get_tree().create_tween()
	move_tween.tween_property($PlayerIcon, "position", current_level.global_position, 0.5).set_trans(Tween.TRANS_SINE)

func _on_texture_button_pressed():
	var event = InputEventAction.new()
	event.action = "dash"
	event.pressed = true
	Input.parse_input_event(event)

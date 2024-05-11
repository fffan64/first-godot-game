extends Control

@onready var worlds: Array = [$WorldIcon, $WorldIcon2, $WorldIcon3, $WorldIcon4, $WorldIcon5]
var current_world: int = 0
var move_tween: Tween

var lengthSwipe = 80
var startPosSwipe: Vector2
var curPosSwipe: Vector2
var swiping = false

var thresholdSwipe = 10

func _ready():
	$PlayerIcon.global_position = worlds[current_world].global_position
	(worlds[current_world] as Control).process_mode = Node.PROCESS_MODE_INHERIT

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
		
	if event.is_action_pressed("move_left") and current_world > 0:
		(worlds[current_world] as Control).process_mode = Node.PROCESS_MODE_DISABLED
		current_world -= 1
		(worlds[current_world] as Control).process_mode = Node.PROCESS_MODE_INHERIT
		tween_icon()
		
	if event.is_action_pressed("move_right") and current_world < worlds.size() - 1:
		(worlds[current_world] as Control).process_mode = Node.PROCESS_MODE_DISABLED
		current_world += 1
		(worlds[current_world] as Control).process_mode = Node.PROCESS_MODE_INHERIT
		tween_icon()
	
	if event.is_action_pressed("jump"):
		if worlds[current_world].level_select_scene:
			worlds[current_world].level_select_scene.parent_world_select = self
			get_tree().root.add_child(worlds[current_world].level_select_scene)
			get_tree().current_scene = worlds[current_world].level_select_scene
			get_tree().root.remove_child(self)
			
func tween_icon():
	move_tween = get_tree().create_tween()
	move_tween.tween_property($PlayerIcon, "position", worlds[current_world].global_position, 0.5).set_trans(Tween.TRANS_SINE)
	

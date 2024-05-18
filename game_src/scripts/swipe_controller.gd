extends Control

@export var lengthSwipe = 80
var startPosSwipe: Vector2
var curPosSwipe: Vector2
var swiping = false

@export var thresholdSwipe = 10


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

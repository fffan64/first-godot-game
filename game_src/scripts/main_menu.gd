extends MarginContainer

@onready var selector1 = $CenterContainer/VBoxContainer/CenterContainer2/Control/VBoxContainer/CenterContainer/HBoxContainer/Selector
@onready var selector2 = $CenterContainer/VBoxContainer/CenterContainer2/Control/VBoxContainer/CenterContainer2/HBoxContainer/Selector
@onready var selector3 = $CenterContainer/VBoxContainer/CenterContainer2/Control/VBoxContainer/CenterContainer3/HBoxContainer/Selector

var current_selection = 0

func _ready():
	set_current_selection(0)
	
func _input(event):
	if event.is_action_pressed("move_down") and current_selection < 2:
		current_selection += 1
		set_current_selection(current_selection)
	elif event.is_action_pressed("move_up") and current_selection > 0:
		current_selection -= 1
		set_current_selection(current_selection)
	elif event.is_action_pressed("jump"):
		handle_selection(current_selection)
	
func handle_selection(_current_selection):
	if _current_selection == 0:
		TransitionScreen.transition()
		await TransitionScreen.on_fade_in_out_finished
		Functions.load_screen_to_scene("res://scenes/world_select/world_select.tscn")
	elif _current_selection == 1:
		pass
	elif _current_selection == 2:
		get_tree().quit()

func set_current_selection(_current_selection):
	selector1.text = ""
	selector2.text = ""
	selector3.text = ""
	if current_selection == 0:
		selector1.text = ">"
	elif current_selection == 1:
		selector2.text = ">"
	elif current_selection == 2:
		selector3.text = ">"

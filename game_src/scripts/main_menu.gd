extends MarginContainer

@onready var selector1 = $CenterContainer/VBoxContainer/Control/CenterContainer2/Control/VBoxContainer/CenterContainer/HBoxContainer/Selector
@onready var selector2 = $CenterContainer/VBoxContainer/Control/CenterContainer2/Control/VBoxContainer/CenterContainer2/HBoxContainer/Selector
@onready var selector3 = $CenterContainer/VBoxContainer/Control/CenterContainer2/Control/VBoxContainer/CenterContainer3/HBoxContainer/Selector

@onready var label_start = $CenterContainer/VBoxContainer/Control/CenterContainer2/Control/VBoxContainer/CenterContainer/HBoxContainer/Control2/Label_Start
@onready var label_options = $CenterContainer/VBoxContainer/Control/CenterContainer2/Control/VBoxContainer/CenterContainer2/HBoxContainer/Control2/Label_Options
@onready var label_quit = $CenterContainer/VBoxContainer/Control/CenterContainer2/Control/VBoxContainer/CenterContainer3/HBoxContainer/Control2/Label_Quit

@onready var animation_player = $AnimationPlayer
@onready var select_sound = $SelectSound
@onready var sound_valid = $SoundValid

var current_selection = 0

func _ready():
	set_current_selection(0)
	animation_player.play("intro")
	TransitionScreen.transition_enter()

	
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
		sound_valid.play()
		TransitionScreen.transition()
		await TransitionScreen.on_fade_in_out_finished
		Functions.load_screen_to_scene("res://scenes/world_select/world_select.tscn")
	elif _current_selection == 1:
		sound_valid.play()
		pass
	elif _current_selection == 2:
		get_tree().quit()

func set_current_selection(_current_selection):
	selector1.text = ""
	selector2.text = ""
	selector3.text = ""
	(selector3.get_parent() as HBoxContainer).modulate = Color.WHITE
	(selector2.get_parent() as HBoxContainer).modulate = Color.WHITE
	(selector1.get_parent() as HBoxContainer).modulate = Color.WHITE
	label_start.text = "START"
	label_options.text = "OPTIONS"
	label_quit.text = "QUIT"
	if current_selection == 0:
		selector1.text = ">"
		(selector1.get_parent() as HBoxContainer).modulate = Color.DARK_ORANGE
		label_start.text = "[center][wave amp=50.0 freq=5.0 connected=1]START[/wave][/center]"
	elif current_selection == 1:
		selector2.text = ">"
		(selector2.get_parent() as HBoxContainer).modulate = Color.DARK_ORANGE
		label_options.text = "[center][wave amp=50.0 freq=5.0 connected=1]OPTIONS[/wave][/center]"
	elif current_selection == 2:
		selector3.text = ">"
		(selector3.get_parent() as HBoxContainer).modulate = Color.DARK_ORANGE
		label_quit.text = "[center][wave amp=50.0 freq=5.0 connected=1]QUIT[/wave][/center]"
	select_sound.play()
	

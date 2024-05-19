extends CanvasLayer

@onready var selector1 = $CenterContainer/VBoxContainer/Control/CenterContainer2/Control/VBoxContainer/CenterContainer/HBoxContainer/Selector
@onready var selector2 = $CenterContainer/VBoxContainer/Control/CenterContainer2/Control/VBoxContainer/CenterContainer3/HBoxContainer/Selector
@onready var selector3 = $CenterContainer/VBoxContainer/Control/CenterContainer2/Control/VBoxContainer/CenterContainer2/HBoxContainer/Selector

@onready var select_sound = $SelectSound
@onready var animation_player = $AnimationPlayer
@onready var label_resume = $CenterContainer/VBoxContainer/Control/CenterContainer2/Control/VBoxContainer/CenterContainer/HBoxContainer/Control2/LabelResume
@onready var label_reload = $CenterContainer/VBoxContainer/Control/CenterContainer2/Control/VBoxContainer/CenterContainer3/HBoxContainer/Control2/LabelReload
@onready var label_quit = $CenterContainer/VBoxContainer/Control/CenterContainer2/Control/VBoxContainer/CenterContainer2/HBoxContainer/Control/LabelQuit

var current_selection = 0

func _ready():
	hide()
	set_current_selection(0)
	
func _input(event):
	if event.is_action_pressed("pause"):
		get_viewport().set_input_as_handled()
		animation_player.play("pause_out")
	if event.is_action_pressed("move_down") and current_selection < 2:
		current_selection += 1
		set_current_selection(current_selection)
	elif event.is_action_pressed("move_up") and current_selection > 0:
		current_selection -= 1
		set_current_selection(current_selection)

func _physics_process(delta):
	if Input.is_action_just_pressed("jump"):
		get_viewport().set_input_as_handled()
		handle_selection(current_selection)
	
func handle_selection(_current_selection):
	if _current_selection == 0:
		animation_player.play("pause_out")
	elif _current_selection == 1:
		animation_player.play("pause_out")
		get_tree().reload_current_scene()
	elif _current_selection == 2:
		animation_player.play("pause_out")
		TransitionScreen.transition()
		await TransitionScreen.on_fade_in_out_finished
		Functions.load_screen_to_scene("res://scenes/world_select/world_select.tscn")
		
func set_current_selection(_current_selection):
	selector1.text = ""
	selector2.text = ""
	selector3.text = ""
	label_resume.text = "RESUME"
	label_reload.text = "RESTART"
	label_quit.text = "QUIT"
	(selector1.get_parent() as HBoxContainer).modulate = Color.WHITE
	(selector2.get_parent() as HBoxContainer).modulate = Color.WHITE
	(selector3.get_parent() as HBoxContainer).modulate = Color.WHITE
	if current_selection == 0:
		selector1.text = ">"
		(selector1.get_parent() as HBoxContainer).modulate = Color.DARK_ORANGE
		label_resume.text = "[center][wave amp=50.0 freq=5.0 connected=1]RESUME[/wave][/center]"
	elif current_selection == 1:
		selector2.text = ">"
		(selector2.get_parent() as HBoxContainer).modulate = Color.DARK_ORANGE
		label_reload.text = "[center][wave amp=50.0 freq=5.0 connected=1]RESTART[/wave][/center]"
	elif current_selection == 2:
		selector3.text = ">"
		(selector3.get_parent() as HBoxContainer).modulate = Color.DARK_ORANGE
		label_quit.text = "[center][wave amp=50.0 freq=5.0 connected=1]QUIT[/wave][/center]"
	select_sound.play()
		

func unpause():
	if get_tree().paused:
		get_tree().paused = false
		hide()

func _on_visibility_changed():
	if visible:
		animation_player.play("pause_in")

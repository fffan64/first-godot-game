extends Node

@onready var ui = %UI
@onready var debug_stats = %DebugStats
@onready var score_label = $ScoreLabel
@onready var coin_hud_label = %CoinHUDLabel
@onready var double_jump_icon = %"DoubleJump icon"
@onready var dash_icon = %"Dash icon"

func _ready():
	ui.show()
	coin_hud_label.text = str(Global.score)
	
	if Global.hasDoubleJump:
		double_jump_icon.visible = true
	if Global.hasDash:
		dash_icon.visible = true
		
	if (Global.Level1.checkpoint != null):
		%Player.global_position = $CheckPoint1.global_position
	else:
		%Player.global_position = $StartLevel.global_position

func _process(delta):
	if Input.is_action_just_pressed("debug_info"):
		debug_stats.visible = !debug_stats.visible
	if Input.is_action_just_pressed("reload_scene"):
		get_tree().reload_current_scene()


func add_point():
	Global.score += 1
	coin_hud_label.text = str(Global.score)
	score_label.text = "You collected " + str(Global.score) + " coins."

func add_potion_blue():
	double_jump_icon.visible = true
	Global.hasDoubleJump = true

func add_potion_red():
	dash_icon.visible = true
	Global.hasDash = true

func spawn_item_pickup(scenePathArray: Array, pos):
	var scene = load(scenePathArray.pick_random())
	var sceneInstance = scene.instantiate()
	sceneInstance.global_position = pos
	get_tree().current_scene.add_child(sceneInstance)

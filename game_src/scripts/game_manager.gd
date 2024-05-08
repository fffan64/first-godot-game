extends Node

var score = 0

@onready var ui = %UI
@onready var debug_stats = %DebugStats
@onready var score_label = $ScoreLabel
@onready var coin_hud_label = %CoinHUDLabel
@onready var double_jump_icon = %"DoubleJump icon"
@onready var dash_icon = %"Dash icon"

var hasDoubleJump = false
var hasDash = false

func _ready():
	ui.show()
	coin_hud_label.text = str(score)

func _process(delta):
	if Input.is_action_just_pressed("debug_info"):
		debug_stats.visible = !debug_stats.visible


func add_point():
	score += 1
	coin_hud_label.text = str(score)
	score_label.text = "You collected " + str(score) + " coins."

func add_potion_blue():
	double_jump_icon.visible = true
	hasDoubleJump = true

func add_potion_red():
	dash_icon.visible = true
	hasDash = true

func spawn_item_pickup(scenePathArray: Array, pos):
	var scene = load(scenePathArray.pick_random())
	var sceneInstance = scene.instantiate()
	sceneInstance.global_position = pos
	get_tree().current_scene.add_child(sceneInstance)

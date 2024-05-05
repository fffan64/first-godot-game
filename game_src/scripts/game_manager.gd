extends Node

var score = 0
@onready var score_label = $ScoreLabel
@onready var double_jump_icon = %"DoubleJump icon"
@onready var dash_icon = %"Dash icon"

var hasDoubleJump = false
var hasDash = false

func add_point():
	score += 1
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

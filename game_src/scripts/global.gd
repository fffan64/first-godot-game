extends Node

var version = 2

var current_level_name: String = "1"
var current_world_name: String  = "1"

var score = 0

var hasDoubleJump = false
var hasDash = false

var completion_level = {
	"world1": {
		"level1": { "checkpoint": null, "cleared": false },
	},
}

var fx_retro_vhs = preload("res://scenes/FX/shader_retro_vhs.tscn").instantiate()

# Called when the node enters the scene tree for the first time.
func _ready():
	var data = Functions.load_data() as Savedata
	if data:
		print_debug("score loaded = " + str(data.score))
		print_debug("completion_level = " + str(data.completion_level))
		Global.hasDash = data.hasDash
		Global.hasDoubleJump = data.hasDoubleJump
		Global.score = data.score
		Global.completion_level = data.completion_level
		
	Events.coin_picked.connect(_on_coin_picked)
	Events.potion_blue_picked.connect(_on_potion_blue_picked)
	Events.potion_red_picked.connect(_on_potion_red_picked)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _input(event):
	if event.is_action_pressed("shaderVHS"):
		if fx_retro_vhs.is_inside_tree():
			fx_retro_vhs.visible = not fx_retro_vhs.visible
		else:
			get_tree().root.add_child(fx_retro_vhs)

func _on_coin_picked(amount: int):
	score += 1

func _on_potion_blue_picked():
	hasDoubleJump = true
	
func _on_potion_red_picked():
	hasDash = true

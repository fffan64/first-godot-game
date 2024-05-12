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


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

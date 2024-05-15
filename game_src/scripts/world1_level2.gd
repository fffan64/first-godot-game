extends Node2D

var parameters: Dictionary # This needs to be here so the scene can receive parameters

@onready var ui = %UI
@onready var score_label = $LevelSpecific/ScoreLabel

func _ready():
	print_debug(parameters)
	Events.coin_picked.connect(_on_coin_picked)
	ui.show()
	
func _on_coin_picked(amount: int):
	score_label.text = "You collected " + str(Global.score) + " coins."

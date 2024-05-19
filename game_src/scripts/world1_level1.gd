extends Node2D

var parameters: Dictionary # This needs to be here so the scene can receive parameters
@export var music = preload("res://assets/music/Blue Sky.ogg")

@onready var ui = %UI
@onready var score_label = $LevelSpecific/ScoreLabel

func _ready():
	print_debug(parameters)
	Events.coin_picked.connect(_on_coin_picked)
	ui.show()
	Music.stream = music
	Music.play()
	TransitionScreen.transition_enter()
	
func _on_coin_picked(amount: int):
	score_label.text = "You collected " + str(Global.score) + " coins."

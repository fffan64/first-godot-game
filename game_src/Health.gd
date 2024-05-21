extends Node
class_name HealthComponent

signal health_changed(current_health: int)
signal died()

var hasDied = false

var current_health:int:
	set(value):
		current_health = clamp(value, 0, max_health)
		health_changed.emit(current_health)
		if current_health <= 0 and !hasDied:
			hasDied = true
			died.emit()

@export var max_health:int = 1:
	set(value):
		max_health = value
		current_health = max_health

#func _ready():
	#current_health = max_health

func damage(hp: int):
	current_health -= hp

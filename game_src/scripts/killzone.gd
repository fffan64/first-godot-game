extends Area2D
class_name Killzone

@export var ignore_invincible_player = false
@onready var timer = $Timer

@export var damage = 1

func _on_body_entered(body):
	if body.health_component:
		body.health_component.damage(damage)

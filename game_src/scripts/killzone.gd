extends Area2D
class_name Killzone

@export var ignore_invincible_player = false
@onready var timer = $Timer

func _on_body_entered(body):
	if body is Player:
		if !body.is_invincible or ignore_invincible_player:
			print("You died!")
			body.die()
			Engine.time_scale = 0.5
			timer.start()
		else:
			print_debug("Player is invincible !")

func _on_timer_timeout():
	Engine.time_scale = 1.0
	TransitionScreen.transition()
	await TransitionScreen.on_fade_in_out_finished
	get_tree().reload_current_scene()

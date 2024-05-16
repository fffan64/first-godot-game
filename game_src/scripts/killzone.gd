extends Area2D
class_name Killzone

@onready var timer = $Timer

func _on_body_entered(body):
	if body is Player:
		print("You died!")
		body.die()
		Engine.time_scale = 0.5
		timer.start()

func _on_timer_timeout():
	Engine.time_scale = 1.0
	TransitionScreen.transition()
	await TransitionScreen.on_fade_in_out_finished
	get_tree().reload_current_scene()

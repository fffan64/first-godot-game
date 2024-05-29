extends State
class_name DeadState

@onready var dead_timer = $DeadTimer

func enter():
	object.dead_sound.play()
	object.get_node("CollisionShape2D").queue_free()
	Engine.time_scale = 0.5
	dead_timer.start()
	
func physics_update(delta):
	var input_dir: Vector2 = object.input()
	# Update character movement velocity
	#object.velocity.x = input_dir.x * object.SPEED
	object.velocity.x = move_toward(object.velocity.x, input_dir.normalized().x * object.SPEED, object.ACCEL)
	

func _on_dead_timer_timeout():
	Engine.time_scale = 1.0
	TransitionScreen.transition()
	await TransitionScreen.on_fade_in_out_finished
	get_tree().reload_current_scene()

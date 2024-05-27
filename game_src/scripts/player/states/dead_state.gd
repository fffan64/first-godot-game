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
	object.velocity.x = input_dir.x * object.SPEED
	
	if not object.is_on_floor():
		if not object.is_ground_pound:
			object.velocity.y += object.gravity * delta
			
	object.move_and_slide()

func _on_dead_timer_timeout():
	Engine.time_scale = 1.0
	TransitionScreen.transition()
	await TransitionScreen.on_fade_in_out_finished
	get_tree().reload_current_scene()

extends State

func enter():
	object.animated_sprite.play("idle")
	object.jump_count = 0
	
func physics_update(delta):
	var input_dir: Vector2 = object.input()
	
	##### TRANSITIONS
	# Check transition to 'Run' state
	if input_dir.x != 0 and object.is_on_floor():
		return change_state("run")
	# Check transition to 'Jump' state
	elif object.is_on_floor() and Input.is_action_just_pressed("jump"):
		return change_state("jump")
	# Check transition to 'Fall' state
	elif !object.is_on_floor():
		return change_state("fall")
	# Check transition to 'Dash' state
	# cant dash while idle
	##### TRANSITIONS

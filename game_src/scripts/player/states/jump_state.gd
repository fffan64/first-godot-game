extends State

func enter():
	if object.jump_count < object.max_jumps:
		if object.fsm_actions.current_state != "dash":
			object.animated_sprite.play("jump")
		
		object.velocity.y = object.JUMP_VELOCITY
		object.jump_count += 1
		object.jump_sound.play()
		object.createJumpParticles(object.position)

func physics_update(delta):
	var input_dir: Vector2 = object.input()

	if object.is_on_floor():
		object.jump_count = 0

	# Handle jump.
	if Global.hasDoubleJump == true:
		object.max_jumps = object.MAX_JUMPS
	else:
		object.max_jumps = 1

	if Input.is_action_just_pressed("jump"):
		enter()
			
	##### TRANSITIONS
	if Input.is_action_just_pressed("move_down") and not object.is_on_floor() and not object.is_ground_pound:
		return change_state("groundpound")
	# Check transition to 'wallslide' state
	elif object.velocity.x == 0 and input_dir.x != 0 and !object.is_on_floor() and object.is_on_wall():
		return change_state("wallslide")
	# Check transition to 'Run' state
	elif object.velocity.y == 0 and input_dir.x != 0 and object.is_on_floor():
		return change_state("run")
	# Check transition to 'Idle' state
	elif object.velocity.y == 0 and input_dir.x == 0 and object.is_on_floor():
		return change_state("idle")
	#####
	
	# Flip the Sprite
	if input_dir.x > 0:
		object.animated_sprite.flip_h = false
	elif input_dir.x < 0:
		object.animated_sprite.flip_h = true
	#####
	
	# Update character movement velocity
	#object.velocity.x = input_dir.x * object.SPEED
	object.velocity.x = move_toward(object.velocity.x, input_dir.normalized().x * object.SPEED, object.ACCEL)
	

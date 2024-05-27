extends State

func enter():
	object.animated_sprite.play("jump")

func physics_update(delta):
	var input_dir: Vector2 = object.input()
	
	
	
	if not object.is_on_floor():
		if not object.is_ground_pound:
			object.velocity.y += object.gravity * delta
	
	
	
	if Input.is_action_just_pressed("jump"):
		return change_state("jump")
	
	##### TRANSITIONS
	# Check transition to 'wallslide' state
	if object.velocity.x == 0 and input_dir.x != 0 and !object.is_on_floor() and object.is_on_wall():
		return change_state("wallslide")
	# Check transition to 'run' state
	elif object.velocity.y == 0 and input_dir.x != 0 and object.is_on_floor():
		return change_state("run")
	# Check transition to 'idle' state
	elif object.velocity.y == 0 and input_dir.x == 0 and object.is_on_floor():
		return change_state("idle")
	
		
	# Flip the Sprite
	if input_dir.x > 0:
		object.animated_sprite.flip_h = false
	elif input_dir.x < 0:
		object.animated_sprite.flip_h = true
	#####
	
	# Update character movement velocity
	object.velocity.x = input_dir.x * object.SPEED
	
	object.move_and_slide()

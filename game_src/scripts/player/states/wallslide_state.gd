extends State

@export var wall_jump_pushback = 400.0
@export var wall_slide_gravity = 50

var input_dir_enter: Vector2 = Vector2.ZERO

func enter():
	object.jump_count = 0
	object.animated_sprite.play("jump")
	object.velocity.y = 0
	input_dir_enter = object.input()
	
func physics_update(delta):
	var input_dir: Vector2 = object.input()
	
	object.velocity.x = input_dir_enter.normalized().x * object.SPEED
	
	object.velocity.y += (wall_slide_gravity * delta)
	object.velocity.y = min(object.velocity.y, wall_slide_gravity)
	if not object.sliding_sound.playing:
		object.sliding_sound.play()
		object.createJumpParticles(object.position, input_dir_enter.normalized().x * 90)

	##### TRANSITIONS
	# Check transition to 'Idle' state
	if object.is_on_floor():
		return change_state("idle")
	### Check transition to 'Jump' state
	elif object.is_on_wall() and Input.is_action_just_pressed("jump") and input_dir.x != 0 and input_dir.normalized().x != input_dir_enter.normalized().x:
		object.velocity.y = object.JUMP_VELOCITY * 2.0
		object.velocity.x = input_dir.normalized().x * wall_jump_pushback
		return change_state("jump")
	# Check transition to 'Fall' state
	elif (!object.is_on_wall() 
	or (object.is_on_wall() and Input.is_action_just_pressed("move_down")) 
	#or (object.is_on_wall() and input_dir.normalized().x == -input_dir_enter.normalized().x)
	):
		return change_state("fall")
	##### TRANSITIONS

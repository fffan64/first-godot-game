extends State

@onready var timer = $Timer

var canPlayWalkSound = true

func enter():
	object.animated_sprite.play("run")
	
func physics_update(delta):
	var input_dir: Vector2 = object.input()
	
	##### TRANSITIONS
	# Check transition to 'Idle' state
	if input_dir.x == 0 and object.is_on_floor():
		return change_state("idle")
	# Check transition to 'Jump' state
	elif object.is_on_floor() and Input.is_action_just_pressed("jump"):
		return change_state("jump")
	# Check transition to 'Fall' state
	elif !object.is_on_floor():
		return change_state("fall")
	##### TRANSITIONS
	
	# Flip the Sprite
	if input_dir.x > 0:
		object.animated_sprite.flip_h = false
	elif input_dir.x < 0:
		object.animated_sprite.flip_h = true
	
	if canPlayWalkSound == true:
		canPlayWalkSound = false;
		if not object.walk_sound.playing:
			object.walk_sound.play()
		timer.start()
		
	# Update character movement velocity
	object.velocity.x = input_dir.x * object.SPEED
	object.move_and_slide()

func _on_timer_timeout():
	canPlayWalkSound = true

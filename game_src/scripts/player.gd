extends CharacterBody2D


const SPEED = 130.0
const JUMP_VELOCITY = -300.0

var jump_count = 0
var max_jumps = 2

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var game_manager = %GameManager
@onready var animated_sprite = $AnimatedSprite2D
@onready var jump_sound = $JumpSound
@onready var walk_sound = $WalkSound
@onready var timer = $Timer

var canPlayWalkSound = true

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
		
	if is_on_floor():
		jump_count = 0

	# Handle jump.
	
	if game_manager.hasDoubleJump == true:
		max_jumps = 2
	else:
		max_jumps = 1
	
	if Input.is_action_just_pressed("jump") and jump_count < max_jumps:
		velocity.y = JUMP_VELOCITY
		jump_count += 1
		jump_sound.play()

	# Get the input direction: -1, 0, 1
	var direction = Input.get_axis("move_left", "move_right")
	
	# Flip the Sprite
	if direction > 0:
		animated_sprite.flip_h = false
	elif direction < 0:
		animated_sprite.flip_h = true
		
	# Play animations
	if is_on_floor():
		if direction == 0:
			animated_sprite.play("idle")
		else:
			animated_sprite.play("run")

			if canPlayWalkSound == true:
				canPlayWalkSound = false;
				if not walk_sound.playing:
					walk_sound.play()
				timer.start()
	else:
		animated_sprite.play("jump")
		
	
	
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()



func _on_timer_timeout():
	canPlayWalkSound = true;


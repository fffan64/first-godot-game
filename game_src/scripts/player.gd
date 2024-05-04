extends CharacterBody2D


const SPEED = 130.0
const JUMP_VELOCITY = -300.0

var DASH_SPEED = 260.0
var dashing = false
var can_dash = true

var jump_count = 0
var max_jumps = 2

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var game_manager = %GameManager
@onready var animated_sprite = $AnimatedSprite2D
@onready var jump_sound = $JumpSound
@onready var walk_sound = $WalkSound
@onready var dash_sound = $DashSound
@onready var timer = $Timer
@onready var retro_vhs_postprocess_fx = %RETRO_VHS_POSTPROCESS_FX

var canPlayWalkSound = true

func _physics_process(delta):
	
	if Input.is_action_just_pressed("shaderVHS"):
		retro_vhs_postprocess_fx.visible = not retro_vhs_postprocess_fx.visible
	
	
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
	
	# Dash
	if game_manager.hasDash and Input.is_action_just_pressed("dash") and can_dash and direction != 0:
		dashing = true
		can_dash = false
		dash_sound.play()
		$Dash_timer.start()
		$Dash_timer_again.start()
	
	# Flip the Sprite
	if direction > 0:
		animated_sprite.flip_h = false
	elif direction < 0:
		animated_sprite.flip_h = true
		
	# Play animations
	if dashing:
		animated_sprite.play("dash")
	elif is_on_floor():
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
		if dashing:
			velocity.x = direction * DASH_SPEED
			#velocity.y = -10
		else:
			velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()



func _on_timer_timeout():
	canPlayWalkSound = true

func _on_dash_timer_timeout():
	dashing = false


func _on_dash_timer_again_timeout():
	can_dash = true

extends CharacterBody2D


const SPEED = 130.0
const JUMP_VELOCITY = -300.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var DASH_SPEED = 260.0
var dashing = false
var can_dash = true

var jump_count = 0
var max_jumps = 2

var wall_jump_pushback = 800
var wall_slide_gravity = 50

var is_wall_sliding_left = false
var is_wall_sliding_right = false

@onready var game_manager = %GameManager
@onready var animated_sprite = $AnimatedSprite2D
@onready var jump_sound = $JumpSound
@onready var walk_sound = $WalkSound
@onready var dash_sound = $DashSound
@onready var timer = $Timer
@onready var retro_vhs_postprocess_fx = %RETRO_VHS_POSTPROCESS_FX

@export var ghost_node: PackedScene
@onready var ghost_timer = $Ghost_timer

var canPlayWalkSound = true

func _physics_process(delta):
	var input_dir: Vector2 = input()
	
	others()
	move(input_dir)
	jump(delta)
	wall_slide(delta)
	dash(input_dir)
	animate(input_dir)


func input() -> Vector2:
	var input_dir = Vector2.ZERO
	input_dir.x = Input.get_axis("move_left", "move_right")
	input_dir = input_dir.normalized()
	return input_dir

func move(direction):
	var velocityCalc = 0
	if dashing:
		velocityCalc = direction.x * DASH_SPEED
		#velocity.y = -10
	else:
		velocityCalc = direction.x * SPEED
	
	if is_wall_sliding_left:
		if direction.x > 0:
			velocity.x = velocityCalc
		#else:
			#velocity.x = move_toward(velocity.x, 0, SPEED)
	if is_wall_sliding_right:
		if direction.x < 0:
			velocity.x = velocityCalc
		#else:
			#velocity.x = move_toward(velocity.x, 0, SPEED)
	
	if !is_wall_sliding_left and !is_wall_sliding_right:
		if direction.x:
			velocity.x = velocityCalc
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
	move_and_slide()

func jump(delta):
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
	
	if Input.is_action_just_pressed("jump"):
		
		if jump_count < max_jumps and !is_on_wall():
			velocity.y = JUMP_VELOCITY
			jump_count += 1
			jump_sound.play()
			createJumpParticles(position)
			
		
		if is_on_wall() and Input.is_action_pressed("move_right"):
			velocity.y = JUMP_VELOCITY
			velocity.x = -wall_jump_pushback
			jump_sound.play()
			createJumpParticles(position)
		if is_on_wall() and Input.is_action_pressed("move_left"):
			velocity.y = JUMP_VELOCITY
			velocity.x = wall_jump_pushback
			jump_sound.play()
			createJumpParticles(position)

func wall_slide(delta):
	if is_on_wall() and !is_on_floor():
		if Input.is_action_pressed("move_left"):
			is_wall_sliding_left = true
		else:
			is_wall_sliding_left = false
		if Input.is_action_pressed("move_right"):
			is_wall_sliding_right = true
		else:
			is_wall_sliding_right = false
	else:
		is_wall_sliding_left = false
		is_wall_sliding_right = false
	
	if is_wall_sliding_left or is_wall_sliding_right:
		velocity.y += (wall_slide_gravity * delta)
		velocity.y = min(velocity.y, wall_slide_gravity)

func dash(direction):
	# Dash
	if game_manager.hasDash and Input.is_action_just_pressed("dash") and can_dash and direction.x != 0:
		dashing = true
		can_dash = false
		dash_sound.play()
		$Dash_timer.start()
		$Dash_timer_again.start()
		ghost_timer.start()

func animate(direction):
	# Flip the Sprite
	if direction.x > 0:
		animated_sprite.flip_h = false
	elif direction.x < 0:
		animated_sprite.flip_h = true
		
	# Play animations
	if dashing:
		animated_sprite.play("dash")
	elif is_on_floor():
		if direction.x == 0:
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
		

func createJumpParticles(pos):
	var inst = preload("res://scenes/explosion_particles.tscn").instantiate()
	inst.position = pos
	get_tree().current_scene.add_child(inst)
	
func add_ghost():
	var direction = input()
	var ghost = ghost_node.instantiate()
	ghost.set_property(position, $AnimatedSprite2D.scale, direction)
	get_tree().current_scene.add_child(ghost)

func others():
	if Input.is_action_just_pressed("shaderVHS"):
		retro_vhs_postprocess_fx.visible = not retro_vhs_postprocess_fx.visible

func _on_timer_timeout():
	canPlayWalkSound = true

func _on_dash_timer_timeout():
	dashing = false
	ghost_timer.stop()


func _on_dash_timer_again_timeout():
	can_dash = true


func _on_ghost_timer_timeout():
	add_ghost()

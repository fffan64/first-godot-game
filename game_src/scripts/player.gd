class_name Player
extends CharacterBody2D

@export var SPEED = 130.0
@export var JUMP_VELOCITY = -300.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")

var is_dead = false

@export var DASH_SPEED = 260.0
var dashing = false
var can_dash = true

var jump_count = 0
@export var MAX_JUMPS = 2
var max_jumps = 2

@export var wall_jump_pushback = 800
@export var wall_slide_gravity = 50

var is_wall_sliding_left = false
var is_wall_sliding_right = false

var is_ground_pound = false
@export var GROUND_POUND_FALL_SPEED = 1000.0

@onready var ui = %UI

@onready var animated_sprite = $AnimatedSprite2D
@onready var jump_sound = $JumpSound
@onready var walk_sound = $WalkSound
@onready var dash_sound = $DashSound
@onready var sliding_sound = $SlidingSound
@onready var animation_player = $AnimationPlayer
@onready var dead_sound = $DeadSound

@onready var timer = $Timer

@export var ghost_node: PackedScene
@onready var ghost_timer = $Ghost_timer

var canPlayWalkSound = true

func _ready():
	is_dead = false
	register_debug_stats()
	Events.slime_simple_died.connect(_on_slime_simple_died)

func _physics_process(delta):
	var input_dir: Vector2 = input()
	
	if not is_dead:
		jump(delta)
		ground_pound(delta)
		wall_slide(delta)
		dash(input_dir)
	move(input_dir, delta)
	animate(input_dir)
	
	# Since there could be multiple collisions, we will need to loop through them
	for i in get_slide_collision_count(): _collide(get_slide_collision(i))

func _collide(collision: KinematicCollision2D):
	#print_debug(collision.get_collider().name)
	if (is_on_floor() or is_on_wall() or collision.get_collider() is Slime_Simple) and is_ground_pound:
		animation_player.play("GroundPoundLand")

func input() -> Vector2:
	var input_dir = Vector2.ZERO
	input_dir.x = Input.get_axis("move_left", "move_right")
	input_dir.y = Input.get_axis("move_up", "move_down")
	input_dir = input_dir.normalized()
	return input_dir

func move(direction, delta):
	# Add the gravity.
	if not is_on_floor():
		if not is_ground_pound:
			velocity.y += gravity * delta
			
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
	if is_on_floor():
		jump_count = 0

	# Handle jump.
	if Global.hasDoubleJump == true:
		max_jumps = MAX_JUMPS
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
	if is_ground_pound:
		return
		
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
		if not sliding_sound.playing:
			sliding_sound.play()
			createJumpParticles(position, 90 if is_wall_sliding_left else -90)

func dash(direction):
	# Dash
	if Global.hasDash and Input.is_action_just_pressed("dash") and can_dash and direction.x != 0:
		dashing = true
		can_dash = false
		dash_sound.play()
		$Dash_timer.start()
		$Dash_timer_again.start()
		ghost_timer.start()

func ground_pound(delta):
	if Input.is_action_just_pressed("move_down") and not is_on_floor() and not is_ground_pound:
		_start_ground_pound()

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
		

func createJumpParticles(pos, rot = null):
	if not pos:
		pos = self.position
	var inst = preload("res://scenes/explosion_particles.tscn").instantiate()
	inst.position = pos
	if rot:
		inst.rotation_degrees = rot
	get_tree().current_scene.add_child(inst)
	
func add_ghost():
	var direction = input()
	var ghost = ghost_node.instantiate()
	ghost.set_property(position, $AnimatedSprite2D.scale, direction)
	get_tree().current_scene.add_child(ghost)

func _on_timer_timeout():
	canPlayWalkSound = true

func _on_dash_timer_timeout():
	dashing = false
	ghost_timer.stop()


func _on_dash_timer_again_timeout():
	can_dash = true

func _on_slime_simple_died():
	if is_ground_pound:
		animation_player.play("GroundPoundLand")
	velocity.y = -200.0
	jump_sound.play()

func _on_ghost_timer_timeout():
	add_ghost()

func _start_ground_pound():
	is_ground_pound = true
	velocity = Vector2.ZERO
	animation_player.play("GroundPoundingIn")

func _ground_pound_move():
	velocity = Vector2(0, GROUND_POUND_FALL_SPEED)
	
func _end_ground_pound():
	is_ground_pound = false

func spring(power: float, direction: float) -> void:
	velocity.x = velocity.x - cos(direction) * power
	velocity.y = -sin(direction) * power

func die():
	is_dead = true
	dead_sound.play()
	get_node("CollisionShape2D").queue_free()

func register_debug_stats():
	if ui.debug_stats:
		ui.debug_stats.add_property(self, "velocity", "")
		ui.debug_stats.add_property(self, "is_on_floor", "")
		ui.debug_stats.add_property(self, "is_on_wall", "")
		ui.debug_stats.add_property(self, "dashing", "")
		ui.debug_stats.add_property(self, "is_wall_sliding_left", "")
		ui.debug_stats.add_property(self, "is_wall_sliding_right", "")
		ui.debug_stats.add_property(self, "is_ground_pound", "")

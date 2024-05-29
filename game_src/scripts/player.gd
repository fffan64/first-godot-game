class_name Player
extends CharacterBody2D

@export var max_hp = 3
@export var SPEED = 130.0
@export var FRICTION = 8.0
@export var ACCEL = 20.0
@export var JUMP_VELOCITY = -300.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")

var is_invincible = false

var jump_count = 0
@export var MAX_JUMPS = 2
var max_jumps = 2

var is_ground_pound = false

var damage_attack = 1

@onready var fsm = $FSM
@onready var fsm_actions = $FSM_Actions
@onready var ui = %UI

@onready var animated_sprite = $AnimatedSprite2D
@onready var jump_sound = $JumpSound
@onready var walk_sound = $WalkSound
@onready var dash_sound = $DashSound
@onready var sliding_sound = $SlidingSound
@onready var animation_player = $AnimationPlayer
@onready var dead_sound = $DeadSound

@onready var invincible_timer = $Invincible_timer

@onready var health_component = $HealthComponent

func _ready():
	fsm.change_state("idle")
	fsm_actions.change_state("idle")
	register_debug_stats()
	Events.bounce_off_enemy.connect(_on_bounce_off_enemy)
	health_component.max_health = max_hp
	health_component.died.connect(_on_died)
	health_component.health_changed.connect(_on_health_changed)

func _on_health_changed(hp: int):
	print_debug("Player current health is " + str(hp))

func _on_died():
	fsm.change_state("dead")

func _physics_process(delta):
	fsm.physics_update(delta)
	fsm_actions.physics_update(delta)
	
	# Apply gravity force and update character movement velocity
	velocity.x = move_toward(velocity.x, 0, FRICTION)
	if !is_on_floor():
		velocity.y += gravity * delta 
	move_and_slide()

func input() -> Vector2:
	var input_dir = Vector2.ZERO
	input_dir.x = Input.get_axis("move_left", "move_right")
	#input_dir.y = Input.get_axis("move_up", "move_down")
	input_dir.y = 0.0
	input_dir = input_dir.normalized()
	return input_dir

func createJumpParticles(pos, rot = null):
	if not pos:
		pos = self.position
	var inst = preload("res://scenes/explosion_particles.tscn").instantiate()
	inst.position = pos
	if rot:
		inst.rotation_degrees = rot
	get_tree().current_scene.add_child(inst)
	

func _on_bounce_off_enemy(amount: float = -200):
	if is_ground_pound:
		animation_player.play("GroundPoundLand")
	velocity.y = amount
	jump_sound.play()

func spring(power: float, direction: float) -> void:
	velocity.x = velocity.x - cos(direction) * power
	velocity.y = -sin(direction) * power

func register_debug_stats():
	if ui:
		if ui.debug_stats:
			ui.debug_stats.add_property(fsm, "current_state", "")
			ui.debug_stats.add_property(fsm_actions, "current_state", "")
			ui.debug_stats.add_property(animated_sprite, "animation", "")
			ui.debug_stats.add_property(self, "velocity", "")
			ui.debug_stats.add_property(self, "is_on_floor", "")
			ui.debug_stats.add_property(self, "is_on_wall", "")
			ui.debug_stats.add_property(self, "dashing", "")
			ui.debug_stats.add_property(self, "is_invincible", "")
			ui.debug_stats.add_property(self, "is_ground_pound", "")



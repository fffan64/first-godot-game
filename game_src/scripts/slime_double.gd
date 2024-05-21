class_name Slime_Double
extends CharacterBody2D

@onready var health_component = $HealthComponent
@onready var detect_player = $DetectPlayer

@export var max_hp = 10
@export var SPEED:float = 90.0
@export var coefVelocityX: float = 1

@export var facing_right = true
@onready var ray_cast_right = $RayCastRight
@onready var ray_cast_down = $RayCastDown
@onready var animated_sprite = $AnimatedSprite2D

@export var check_edge = true

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	print_debug("Setting slime health to " + str(max_hp))
	health_component.max_health = max_hp
	health_component.died.connect(die)
	health_component.health_changed.connect(on_health_changed)
	set_speed()
	if !facing_right:
		scale.x = abs(scale.x) * -1

func on_health_changed(hp: int):
	print_debug("Slime double current health is " + str(hp))

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	if ray_cast_right.is_colliding():
		flip()

	if check_edge:
		if !ray_cast_down.is_colliding() and is_on_floor():
			flip()
			
	#velocity.x = move_toward(velocity.x, SPEED, coefVelocityX * delta)
	velocity.x = lerp(velocity.x, SPEED, coefVelocityX * delta)
	velocity.x = clamp(velocity.x, -abs(SPEED), abs(SPEED))
	#print_debug(velocity.x)
	move_and_slide()

func flip():
	facing_right = !facing_right
	scale.x = abs(scale.x) * -1
	set_speed()

func set_speed():	
	if facing_right:
		SPEED = abs(SPEED)
	else:
		SPEED = abs(SPEED) * -1
	
func die():
	set_physics_process(false)
	if $SlimeCollision:
		$SlimeCollision.queue_free()
	$AnimationPlayer.play("destroy")



func _on_detect_player_body_entered(body):
	if body is Player:
		var dir = (body.global_position - self.position).normalized()
		print_debug(dir);
		if dir.x < 0 and facing_right:
			flip()
		if dir.x > 0 and !facing_right:
			flip()

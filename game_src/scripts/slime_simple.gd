class_name Slime_Simple
extends CharacterBody2D

var SPEED = 60.0

@export var facing_right = true
@onready var ray_cast_right = $RayCastRight
@onready var ray_cast_down = $RayCastDown
@onready var animated_sprite = $AnimatedSprite2D

@export var check_edge = true

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	set_speed()
	if !facing_right:
		scale.x = abs(scale.x) * -1

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta


	if ray_cast_right.is_colliding():
		flip()

	if check_edge:
		if !ray_cast_down.is_colliding() and is_on_floor():
			flip()
			
	velocity.x = SPEED
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

func _on_destroy_zone_body_entered(body):
	if body is Player:
		var angleAttack = rad_to_deg(body.get_angle_to(self.position))
		if angleAttack > 10 and angleAttack < 170:
			die()
			if body.is_ground_pound:
				body.animation_player.play("GroundPoundLand")
			body.velocity.y = -200.0
			body.jump_sound.play()

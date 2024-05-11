extends CharacterBody2D


var SPEED = 60.0

var facing_right = true
@onready var ray_cast_right = $RayCastRight
@onready var ray_cast_down = $RayCastDown
@onready var animated_sprite = $AnimatedSprite2D

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta


	if ray_cast_right.is_colliding():
		flip()

	if !ray_cast_down.is_colliding() and is_on_floor():
		flip()
	
	velocity.x = SPEED
	move_and_slide()

func flip():
	facing_right = !facing_right
	
	scale.x = abs(scale.x) * -1
	if facing_right:
		SPEED = abs(SPEED)
	else:
		SPEED = abs(SPEED) * -1
	

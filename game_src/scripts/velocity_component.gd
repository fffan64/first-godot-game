extends Node

@export var SPEED = 60.0
# Get the gravity from the project settings to be synced with RigidBody nodes.
@export var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")
@export var facing_right = true

#func _ready():
	#detection_component.raycast_front_triggered.connect(on_raycast_front_triggered)
	#detection_component.raycast_down_triggered.connect(on_raycast_down_triggered)

func on_raycast_front_triggered():
	flip()
	
func on_raycast_down_triggered():
	pass
	
#func _physics_process(delta):
	## Add the gravity.
	#if not is_on_floor():
		#velocity.y += gravity * delta
#
	#if check_edge:
		#if !ray_cast_down.is_colliding() and is_on_floor():
			#flip()
			#
	#velocity.x = SPEED
	#move_and_slide()

func flip():
	facing_right = !facing_right
	#scale.x = abs(scale.x) * -1
	set_speed()

func set_speed():	
	if facing_right:
		SPEED = abs(SPEED)
	else:
		SPEED = abs(SPEED) * -1

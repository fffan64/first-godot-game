extends State
class_name GroundPoundState

@export var GROUND_POUND_FALL_SPEED = 1000.0

@onready var invincible_timer = $Invincible_timer

func enter():
	object.damage_attack = 3
	object.is_invincible = true
	object.is_ground_pound = true
	object.velocity = Vector2.ZERO
	object.animation_player.play("GroundPoundingIn")
	
func physics_update(delta):
	var input_dir: Vector2 = object.input()
	
	if object.is_ground_pound:
		for i in object.get_slide_collision_count(): _collide(object.get_slide_collision(i))
	else:
		##### TRANSITIONS
		# Check transition to 'Jump' state
		if object.is_on_floor() and Input.is_action_just_pressed("jump"):
			return change_state("jump")
		# Check transition to 'Idle' state
		elif input_dir.x == 0 and object.is_on_floor():
			return change_state("idle")
		# Check transition to 'Run' state
		elif input_dir.x != 0 and object.is_on_floor():
			return change_state("run")
		# Check transition to 'Fall' state
		elif !object.is_on_floor():
			return change_state("fall")
		##### TRANSITIONS
	

func _collide(collision: KinematicCollision2D):
	#print_debug(collision.get_collider().name)
	#if (is_on_floor() or is_on_wall() or collision.get_collider() is Slime_Simple) and is_ground_pound:
	if (object.is_on_floor() or object.is_on_wall()) and object.is_ground_pound:
		object.animation_player.play("GroundPoundLand")


func _ground_pound_move():
	invincible_timer.start()
	object.velocity = Vector2(0, GROUND_POUND_FALL_SPEED)
	
func _end_ground_pound():
	object.is_ground_pound = false

func _on_invincible_timer_timeout():
	object.is_invincible = false

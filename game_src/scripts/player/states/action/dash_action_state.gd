extends State
class_name DashState

@onready var dash_timer = $Dash_timer
@onready var dash_timer_again = $Dash_timer_again
@onready var ghost_timer = $Ghost_timer

@export var ghost_node: PackedScene
@export var DASH_SPEED = 260.0

var dashing = false
var can_dash = true
var previous_anim: String = "idle"

func enter():
	previous_anim = object.animated_sprite.animation
	object.animated_sprite.play("dash")
	dashing = true
	can_dash = false
	object.dash_sound.play()
	dash_timer.start()
	dash_timer_again.start()
	ghost_timer.start()
	
func physics_update(delta):
	var input_dir: Vector2 = object.input()

	##### TRANSITIONS
	if dash_timer.is_stopped():
		return change_state("idle")
	##### TRANSITIONS
	
	# Update character movement velocity
	object.velocity.x = input_dir.x * DASH_SPEED
	#object.velocity.x = move_toward(object.velocity.x, input_dir.normalized().x * DASH_SPEED, object.ACCEL)
	

func exit():
	object.animated_sprite.play(object.fsm.current_state)

func add_ghost():
	var input_dir: Vector2 = object.input()
	var ghost = ghost_node.instantiate()
	ghost.set_property(object.position, object.animated_sprite.scale, input_dir)
	get_tree().current_scene.add_child(ghost)
	
func _on_dash_timer_timeout():
	dashing = false
	ghost_timer.stop()

func _on_dash_timer_again_timeout():
	can_dash = true
	
func _on_ghost_timer_timeout():
	add_ghost()

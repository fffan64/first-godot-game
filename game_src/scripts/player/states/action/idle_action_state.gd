extends State

func enter():
	#object.animated_sprite.play("idle")
	pass
	
func physics_update(delta):
	var input_dir: Vector2 = object.input()
	##### TRANSITIONS
	# Check transition to 'Dash' state
	if Global.hasDash and Input.is_action_just_pressed("dash") and input_dir.x != 0 and object.fsm.current_state != "wallslide" and object.fsm.current_state != "dead" and object.fsm.current_state != "groundpound":
		return change_state("dash")
	##### TRANSITIONS

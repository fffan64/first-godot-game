extends Area2D

@export var pipeTeleportTo: Node

var playerOnTop = null

func _on_body_entered(body):
	playerOnTop = body
	
func _process(delta):
	if pipeTeleportTo == null:
		return
	if Input.is_action_just_pressed("move_down") and playerOnTop != null:
		print_debug('GO IN PIPE !!!')
		print_debug(pipeTeleportTo)
		playerOnTop.position = pipeTeleportTo.position + Vector2(0, -10)

func _on_body_exited(body):
	playerOnTop = null

extends Area2D

@export var pipeTeleportTo: Node

var playerOnTop = null

func _on_body_entered(body):
	playerOnTop = body
	
func _process(delta):
	if pipeTeleportTo == null:
		return
	if Input.is_action_just_pressed("move_down") and playerOnTop != null:
		get_tree().paused = true
		TransitionScreen.transition()
		await TransitionScreen.on_fade_in_out_finished
		playerOnTop.position = pipeTeleportTo.position + Vector2(0, -10)
		get_tree().paused = false

func _on_body_exited(body):
	playerOnTop = null

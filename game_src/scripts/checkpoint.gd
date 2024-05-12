extends Area2D



func _on_body_entered(body):
	if body is Player:
		Global.completion_level.world1.level1.checkpoint = global_position

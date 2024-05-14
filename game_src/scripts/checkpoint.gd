extends Area2D
class_name Checkpoint

func _on_body_entered(body):
	if body is Player:
		Functions.set_checkpoint(Global.current_world_name, Global.current_level_name, global_position)

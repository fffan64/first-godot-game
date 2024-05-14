extends Area2D
class_name EndLevel

func _on_body_entered(body):
	if body is Player:
		body.set_process(false)
		body.set_physics_process(false)
		Functions.set_level_cleared(Global.current_world_name, Global.current_level_name, true)
		Functions.set_checkpoint(Global.current_world_name, Global.current_level_name, null)
		Functions.save_data()
		Functions.load_screen_to_scene("res://scenes/world_select/world_select.tscn")

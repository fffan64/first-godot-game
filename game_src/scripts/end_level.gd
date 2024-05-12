extends Area2D


func _on_body_entered(body):
	if body is Player:
		Global.completion_level.world1.level1.cleared = true
		Global.completion_level.world1.level1.checkpoint = null
		body.set_process(false)
		body.set_physics_process(false)
		Functions.save_data()
		Functions.load_screen_to_scene("res://scenes/world_select/world_select.tscn")

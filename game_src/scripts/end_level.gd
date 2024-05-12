extends Area2D


func _on_body_entered(body):
	if body is Player:
		Global.Level1.cleared = true
		Global.Level1.checkpoint = null
		body.set_process(false)
		body.set_physics_process(false)
		Functions.load_screen_to_scene("res://scenes/world_select/level_select.tscn")

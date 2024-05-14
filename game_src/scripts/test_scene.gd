extends Control

func _on_button_pressed():
	Functions.load_screen_to_scene("res://scenes/world1_level1.tscn", {"test":"test"})

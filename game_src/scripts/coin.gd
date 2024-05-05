extends Area2D

@onready var animation_player = $AnimationPlayer

func _on_body_entered(body):
	body.game_manager.add_point()
	animation_player.play("pickup")

extends Area2D

@onready var animation_player = $AnimationPlayer

func _on_body_entered(body):
	body.game_manager.add_potion_red()
	animation_player.play('pickup')

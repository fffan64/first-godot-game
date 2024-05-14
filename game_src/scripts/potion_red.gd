extends Area2D

@onready var animation_player = $AnimationPlayer

func _on_body_entered(body):
	Events.potion_red_picked.emit()
	animation_player.play('pickup')

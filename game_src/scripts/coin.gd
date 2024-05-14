extends Area2D
class_name Coin

@onready var animation_player = $AnimationPlayer

func _on_body_entered(body):
	Events.coin_picked.emit(1)
	animation_player.play("pickup")

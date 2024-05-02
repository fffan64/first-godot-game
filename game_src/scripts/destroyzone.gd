extends Area2D

@onready var animation_player = %AnimationPlayer

func _on_body_entered(body):
	print("Enemy died!")
	(body as CharacterBody2D).velocity.y = -200.0
	(body as CharacterBody2D).jump_sound.play()
	animation_player.play("destroy")


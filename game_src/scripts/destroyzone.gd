extends Area2D

@onready var animation_player = %AnimationPlayer

func _on_body_entered(body):
	print("Enemy died!")
	get_node("..").set_physics_process(false)
	$"../SlimeCollision".queue_free()
	animation_player.play("destroy")
	(body as CharacterBody2D).velocity.y = -200.0
	(body as CharacterBody2D).jump_sound.play()


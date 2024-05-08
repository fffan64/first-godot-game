@tool
extends Area2D

enum BlockColor {BROWN, LIGHT_BROWN, LIGHT_RED, GREY}
@export var block_color: BlockColor

func _ready():
	if block_color == BlockColor.BROWN:
		$Sprite2D.frame = 1
	elif block_color == BlockColor.LIGHT_BROWN:
		$Sprite2D.frame = 3
	elif block_color == BlockColor.LIGHT_RED:
		$Sprite2D.frame = 5
	elif block_color == BlockColor.GREY:
		$Sprite2D.frame = 8
	else:
		$Sprite2D.frame = 1

	
func _on_body_entered(body):
	if not Engine.is_editor_hint():
		$Trigger.queue_free()
		$Area2D/TriggerTop.queue_free()
		$Sprite2D.queue_free()
		$StaticBody2D.queue_free()
		destroy_block()
		
func destroy_block():
	$BlockSound.play()
	$AnimationPlayer.play("destroy")
	


func _on_area_2d_body_entered(body):
	if not Engine.is_editor_hint():
		if body.is_ground_pound:
			$Area2D/TriggerTop.queue_free()
			$Trigger.queue_free()
			$Sprite2D.queue_free()
			$StaticBody2D.queue_free()
			destroy_block()

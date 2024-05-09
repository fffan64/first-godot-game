extends Area2D

enum BlockColor {BROWN, LIGHT_BROWN, LIGHT_RED, GREY}
@export var block_color: BlockColor = BlockColor.BROWN:
	set(mod_value):
		block_color = mod_value
		match block_color:
			BlockColor.BROWN:
				$Sprite2D.frame = 1
			BlockColor.LIGHT_BROWN:
				$Sprite2D.frame = 3
			BlockColor.LIGHT_RED:
				$Sprite2D.frame = 5
			BlockColor.GREY:
				$Sprite2D.frame = 8
			_:
				$Sprite2D.frame = 1
	
func _on_body_entered(body):
	$Trigger.queue_free()
	$Area2D/TriggerTop.queue_free()
	$Sprite2D.queue_free()
	$StaticBody2D.queue_free()
	destroy_block()
		
func destroy_block():
	$BlockSound.play()
	$AnimationPlayer.play("destroy")
	


func _on_area_2d_body_entered(body):
	if body.is_ground_pound:
		$Area2D/TriggerTop.queue_free()
		$Trigger.queue_free()
		$Sprite2D.queue_free()
		$StaticBody2D.queue_free()
		destroy_block()

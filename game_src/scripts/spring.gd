@tool
extends Area2D

@export var spring_power: int = 400

enum SpringColor {GREEN, YELLOW, ORANGE, VIOLET}
@export var spring_color: SpringColor = SpringColor.GREEN:
	set(mod_value):
		spring_color = mod_value
		match spring_color:
			SpringColor.GREEN:
				$Sprite2D.region_rect = Rect2(112, 128, 16, 16)
			SpringColor.YELLOW:
				$Sprite2D.region_rect = Rect2(112, 96, 16, 16)
			SpringColor.ORANGE:
				$Sprite2D.region_rect = Rect2(112, 80, 16, 16)
			SpringColor.VIOLET:
				$Sprite2D.region_rect = Rect2(112, 112, 16, 16)
			_:
				$Sprite2D.region_rect = Rect2(112, 128, 16, 16)

func _on_body_entered(body):
	body.spring(spring_power, rotation + PI/2.0)
	$AnimationPlayer.play("Spring")

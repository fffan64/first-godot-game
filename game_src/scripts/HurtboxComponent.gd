extends Area2D

@export var health_component: HealthComponent

func _on_body_entered(body):
	if body is Player:
		#var angleAttack = rad_to_deg(body.get_angle_to(self.position))
		#if angleAttack > 10 and angleAttack < 170:
		if health_component:
			health_component.damage(1)
		Events.bounce_off_enemy.emit()

extends Area2D

@export var player: Player
@export var checkpoint: Checkpoint

func _ready():
	if Functions.get_checkpoint(Global.current_world_name, Global.current_level_name) != null:
		player.global_position = checkpoint.global_position
	else:
		player.global_position = self.global_position

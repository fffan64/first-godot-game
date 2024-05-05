@tool
extends Area2D

enum State {UNBUMPED, BUMPED}
var state: int = State.UNBUMPED
var original_position: Vector2
@onready var game_manager = %GameManager

enum BlockColor {BROWN, LIGHT_BROWN, LIGHT_RED, GREY}
@export var block_color: BlockColor

func _ready():
	if block_color == BlockColor.BROWN:
		$Sprite2D.frame = 32
	elif block_color == BlockColor.LIGHT_BROWN:
		$Sprite2D.frame = 35
	elif block_color == BlockColor.LIGHT_RED:
		$Sprite2D.frame = 36
	elif block_color == BlockColor.GREY:
		$Sprite2D.frame = 39
	else:
		$Sprite2D.frame = 32
	original_position = position
	
func _on_body_entered(body):
	if not Engine.is_editor_hint():
		$Trigger.queue_free()
	bump_block()
		
func bump_block():
	$BlockSound.play()
	state = State.BUMPED
	
	if block_color == BlockColor.BROWN:
		$Sprite2D.frame = 16
	elif block_color == BlockColor.LIGHT_BROWN:
		$Sprite2D.frame = 18
	elif block_color == BlockColor.LIGHT_RED:
		$Sprite2D.frame = 20
	elif block_color == BlockColor.GREY:
		$Sprite2D.frame = 22
	else:
		$Sprite2D.frame = 16
	
	game_manager.spawn_item_pickup(
		[	"res://scenes/coin.tscn",
			"res://scenes/potion_blue.tscn", 
			"res://scenes/potion_red.tscn"
		], self.global_position + Vector2(0, -30))
	bump_upwards()
	var timer = get_tree().create_timer(0.2)
	await timer.timeout
	return_to_original_position()
	
func bump_upwards():
	position.y -= 6
	
func return_to_original_position():
	position = original_position

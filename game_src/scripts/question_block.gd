extends Area2D

enum State {UNBUMPED, BUMPED}
var state: int = State.UNBUMPED
var original_position: Vector2

enum BlockColor {BROWN, LIGHT_BROWN, LIGHT_RED, GREY}
@export var block_color: BlockColor = BlockColor.BROWN:
	set(mod_value):
		block_color = mod_value
		match block_color:
			BlockColor.BROWN:
				$Sprite2D.frame = 32
			BlockColor.LIGHT_BROWN:
				$Sprite2D.frame = 35
			BlockColor.LIGHT_RED:
				$Sprite2D.frame = 36
			BlockColor.GREY:
				$Sprite2D.frame = 39
			_:
				$Sprite2D.frame = 32

var body_on_top = null

func _ready():
	
	original_position = position
	
func _on_body_entered(body):
	if body is Player:
		bump_block()
		
func bump_block(bump_down = false):
	$Trigger.queue_free()
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
	
	var spawnPos = self.global_position + Vector2(0, -30)
	if bump_down:
		spawnPos = self.global_position + Vector2(0, 10)
	Functions.spawn_item_pickup(
		[	"res://scenes/coin.tscn",
			"res://scenes/potion_blue.tscn", 
			"res://scenes/potion_red.tscn"
		], spawnPos)
	if bump_down:
		bump_downwards()
	else:
		bump_upwards()
	if (body_on_top and body_on_top is Slime_Simple):
		body_on_top.die()
	var timer = get_tree().create_timer(0.2)
	await timer.timeout
	return_to_original_position()
	
func bump_downwards():
	position.y += 6
func bump_upwards():
	position.y -= 6
	
func return_to_original_position():
	position = original_position


func _on_area_2d_body_entered(body):
	body_on_top = body
	
	if body_on_top is Player:
		if body_on_top.is_ground_pound and state == State.UNBUMPED:
			bump_block(true)
		


func _on_area_2d_body_exited(body):
	body_on_top = null

extends Path2D

@export var loop = true
@export var speed = 2.0
@export var speed_scale = 1.0

enum PlatformColor {GREEN, BROWN, YELLOW, BLUE}
@export var platform_color: PlatformColor = PlatformColor.GREEN:
	set(mod_value):
		platform_color = mod_value
		match platform_color:
			PlatformColor.GREEN:
				$AnimatableBody2D/Sprite2D.region_rect = Rect2(16, 0, 32, 9)
			PlatformColor.BROWN:
				$AnimatableBody2D/Sprite2D.region_rect = Rect2(16, 16, 32, 9)
			PlatformColor.YELLOW:
				$AnimatableBody2D/Sprite2D.region_rect = Rect2(16, 32, 32, 9)
			PlatformColor.BLUE:
				$AnimatableBody2D/Sprite2D.region_rect = Rect2(16, 48, 32, 9)
			_:
				$AnimatableBody2D/Sprite2D.region_rect = Rect2(16, 0, 32, 9)

@onready var path = $PathFollow2D
@onready var animation = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	if not loop:
		animation.play("move")
		animation.speed_scale = speed_scale
		set_process(false)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	path.progress += speed

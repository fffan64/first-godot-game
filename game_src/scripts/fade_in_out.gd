extends CanvasLayer
class_name FadeInOut

signal on_fade_in_out_finished

@onready var anim = $Anim
@onready var color_rect = $ColorRect

func _ready():
	self.process_mode = Node.PROCESS_MODE_ALWAYS
	color_rect.visible = false
	anim.animation_finished.connect(_on_animation_finished)
	
func _on_animation_finished(anim_name):
	if anim_name == "fade_out":
		on_fade_in_out_finished.emit()
		anim.play("fade_in")
	elif anim_name == "fade_in":
		color_rect.visible = false

func transition():
	color_rect.visible = true
	#anim.speed_scale = speed_scale
	anim.play("fade_out")

func transition_enter():
	color_rect.visible = true
	#anim.speed_scale = speed_scale
	anim.play("fade_in")

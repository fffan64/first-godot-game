extends CanvasLayer

@onready var debug_stats = $DebugStats
@onready var coin_hud_label = $"Coin Icon/CoinHUDLabel"
@onready var double_jump_icon = $"DoubleJump icon"
@onready var dash_icon = $"Dash icon"

func _ready():
	coin_hud_label.text = str(Global.score)
	
	if Global.hasDoubleJump:
		double_jump_icon.visible = true
	if Global.hasDash:
		dash_icon.visible = true
		
	Events.coin_picked.connect(_on_coin_picked)
	Events.potion_blue_picked.connect(_on_potion_blue_picked)
	Events.potion_red_picked.connect(_on_potion_red_picked)

func _process(delta):
	if Input.is_action_just_pressed("debug_info"):
		debug_stats.visible = !debug_stats.visible
	if Input.is_action_just_pressed("reload_scene"):
		get_tree().reload_current_scene()
		
func _on_coin_picked(amount: int):
	coin_hud_label.text = str(Global.score)

func _on_potion_blue_picked():
	double_jump_icon.visible = true

func _on_potion_red_picked():
	dash_icon.visible = true

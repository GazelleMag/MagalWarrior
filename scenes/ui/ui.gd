extends CanvasLayer

@onready var player: Node2D = $"../Player"
@onready var player_health_bar: ProgressBar = $MarginContainer/VBoxContainer/PlayerHealthBar
@onready var action_bar: HBoxContainer = $MarginContainer/VBoxContainer/ActionBar

func _ready() -> void:
	player.mouse_click.connect(handle_mouse_click)
	player.health_changed.connect(update_health_bar)
	
func update_health_bar() -> void:
	player_health_bar.update_health_bar(player)
	
func handle_mouse_click(click_type: String) -> void:
	action_bar.handle_mouse_click(click_type)
	
func handle_mouse_cooldown(cooldown_status: bool, click_type: String) -> void:
	if click_type == "mouse1":
		player.mouse1_cooldown = cooldown_status
	elif click_type == "mouse2":
		player.mouse2_cooldown = cooldown_status

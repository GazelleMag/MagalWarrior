extends CanvasLayer

@onready var player: Node2D = $"../Player"
@export var player_health_bar: ProgressBar
@export var action_bar: HBoxContainer

func _ready() -> void:
	player.mouse_click.connect(handle_mouse_click)
	player.health_changed.connect(update_health_bar)
	
func update_health_bar() -> void:
	player_health_bar.update_health_bar(player)
	
func handle_mouse_click(click_type: String) -> void:
	action_bar.handle_mouse_click(click_type)
	
func handle_mouse_cooldown(cooldown_status: bool, click_type: String) -> void:
	if player != null:
		player.handle_mouse_cooldown(cooldown_status, click_type)

func set_ability_action_bar(abilities: Array[String]) -> void:
	action_bar.set_ability_action_bar(abilities)

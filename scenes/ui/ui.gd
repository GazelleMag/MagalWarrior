extends CanvasLayer

@onready var player: Node2D = $"../Player"
@export var player_health_bar: ProgressBar
@export var action_bar: HBoxContainer
@export var warning_label: Label
@export var warning_timer: Timer

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

func set_ability_action_bar(abilities: Array[Ability]) -> void:
	action_bar.set_ability_action_bar(abilities)
	
func show_warning_message(message: String) -> void:
	warning_label.text = message
	warning_label.visible = true

func reset_warning_message() -> void:
	warning_label.text = ""
	warning_label.visible = false

# signals
func _on_invisible_wall_area_body_entered(body):
	if body.name == "Player":
		if not warning_timer.is_stopped():
			warning_timer.stop()
		show_warning_message("Defeat nearby enemies before moving on.")

func _on_invisible_wall_area_body_exited(_body):
	warning_timer.start()

func _on_warning_timer_timeout():
	reset_warning_message()

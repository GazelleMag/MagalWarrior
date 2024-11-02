extends CanvasLayer

@onready var player: Node2D = $"../Player"
@export var player_health_bar: TextureProgressBar
@export var action_bar: HBoxContainer
@export var warning_label: Label
@export var warning_timer: Timer
@export var effects_bar: HBoxContainer

func _ready() -> void:
	player.key_use.connect(handle_key_use)
	player.health_changed.connect(update_health_bar)
	player.effect_started.connect(add_effect)
	player.effect_ended.connect(remove_effect)
	
func update_health_bar() -> void:
	player_health_bar.update_health_bar(player)

func handle_key_use(key: String) -> void:
	action_bar.handle_key_use(key)

func handle_cooldown(cooldown_status: bool, key: String) -> void:
	if player != null:
		player.handle_cooldown(cooldown_status, key)

func set_ability_action_bar(abilities: Array[Ability]) -> void:
	action_bar.set_ability_action_bar(abilities)
	
func show_warning_message(message: String) -> void:
	warning_label.text = message
	warning_label.visible = true

func reset_warning_message() -> void:
	warning_label.text = ""
	warning_label.visible = false

func add_effect(effect_name: String) -> void:
	effects_bar.add_effect(effect_name)
	
func remove_effect(effect_name: String) -> void:
	effects_bar.remove_effect(effect_name)

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

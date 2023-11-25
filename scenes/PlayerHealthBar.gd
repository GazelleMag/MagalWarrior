extends ProgressBar

var player: Node2D
var UI: CanvasLayer

func _ready() -> void:
	UI = get_parent().get_script()
	if UI:
		player = UI.player
	if player:
		player.health_changed.connect(update_health_bar)

func update_health_bar() -> void:
	value = player.currentHealth * 100 / player.maxHealth

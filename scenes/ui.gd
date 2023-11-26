extends CanvasLayer

var player: Node2D
var player_health_bar: ProgressBar

func _ready() -> void:
	player = $"../Player"
	player_health_bar = $MarginContainer/PlayerHealthBar
	player.health_changed.connect(update_health_bar)
	
func update_health_bar() -> void:
	player_health_bar.update_health_bar(player)

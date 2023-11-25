extends CanvasLayer

var player: Node2D
var player_health_bar: ProgressBar

func _ready() -> void:
	player = $"../Player"
	player_health_bar = $MarginContainer/PlayerHealthBar

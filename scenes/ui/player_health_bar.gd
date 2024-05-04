extends ProgressBar

func update_health_bar(player: Node2D) -> void:
	value = player.current_health * 100 / player.max_health

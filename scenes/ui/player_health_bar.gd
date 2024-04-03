extends ProgressBar

func update_health_bar(player: Node2D) -> void:
	value = player.currentHealth * 100 / player.maxHealth

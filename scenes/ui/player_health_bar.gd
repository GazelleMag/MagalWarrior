extends TextureProgressBar

func update_health_bar(player: Node2D) -> void:
	value = player.health_component.current_health * 100 / player.health_component.max_health

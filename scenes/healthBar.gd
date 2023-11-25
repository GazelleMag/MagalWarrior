extends ProgressBar

var character: Node2D

func _ready() -> void:
	character = get_parent()
	if character:
		character.health_changed.connect(update_health_bar)
	

func update_health_bar() -> void:
	value = character.currentHealth * 100 / character.maxHealth

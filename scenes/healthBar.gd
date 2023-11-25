extends ProgressBar

var character: Node2D

func _ready() -> void:
	character = get_parent()
	if character:
		character.healthChanged.connect(update)
	

func update() -> void:
	value = character.currentHealth * 100 / character.maxHealth

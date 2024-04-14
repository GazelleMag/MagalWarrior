extends ProgressBar

@onready var currentHealth: int = maxHealth
var maxHealth: int = 100

func _ready() -> void:
	value = 100
	
func update_health_bar(damage: int) -> void:
	currentHealth = currentHealth - damage
	value = float(currentHealth) * 100 / maxHealth

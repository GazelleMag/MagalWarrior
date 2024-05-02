extends ProgressBar

var current_health: int
var max_health: int

func _ready() -> void:
	value = 100
	
func update_health_bar(damage: int) -> void:
	current_health = current_health - damage
	value = float(current_health) * 100 / max_health

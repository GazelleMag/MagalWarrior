extends ProgressBar

# components
@export var health_component: Node2D

func _ready() -> void:
	value = 100
	
func update_health_bar() -> void:
	value = float(health_component.current_health) * 100 / health_component.max_health

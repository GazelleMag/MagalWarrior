extends Node2D

var current_health: int
var max_health: int
@onready var health_bar: TextureProgressBar = $HealthBar

func _ready() -> void:
	health_bar.value = 100
	
func update() -> void:
	health_bar.value = float(current_health) * 100 / max_health

func update_health(damage: int) -> void:
	current_health = current_health - damage
	update()

func reset_health() -> void:
	current_health = max_health
	update()

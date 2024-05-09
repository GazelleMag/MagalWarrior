extends Node2D

var current_health: int
var max_health: int

func update_health(damage: int) -> void:
	current_health = current_health - damage

extends Node2D

var current_health: int
var max_health: int

#func update_health(damage: int) -> void:
#	current_health = current_health - damage
	
func update_health(value: int) -> void:
	current_health = current_health + value # value can be positive or negative

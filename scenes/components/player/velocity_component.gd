extends Node2D

var speed
var character_direction: Vector2
var last_character_direction: Vector2 = Vector2.DOWN
var last_character_direction_name: String = "down"

func _process(_delta: float) -> void:
	update_direction()

func update_direction() -> void:
	character_direction = Input.get_vector("left", "right", "up", "down")

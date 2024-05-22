extends Node2D

var speed
var character_direction: Vector2
var last_character_direction: Vector2 = Vector2.DOWN
var last_character_direction_name: String = "down"

func _process(_delta: float) -> void:
	update_direction()
	update_last_character_direction()

func update_direction() -> void:
	character_direction = Input.get_vector("left", "right", "up", "down")

func update_last_character_direction() -> void:
	if character_direction != Vector2.ZERO:
		if abs(character_direction.x) > abs(character_direction.y):
			last_character_direction = Vector2(character_direction.x, 0).normalized()
		else:
			last_character_direction = Vector2(0, character_direction.y).normalized()

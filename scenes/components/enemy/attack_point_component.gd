extends Area2D

@onready var character: CharacterBody2D = get_parent()
@onready var attack_point_collision_shape: CollisionShape2D = $CollisionShape2D
var attack_point_offset: float = 30.0

func update_attack_point_position(direction: Vector2) -> void:
	if direction != Vector2.ZERO:
		if abs(direction.x) > abs(direction.y):
			character.last_character_direction = Vector2(direction.x, 0).normalized()
		else:
			character.last_character_direction = Vector2(0, direction.y).normalized()
	attack_point_collision_shape.global_position = global_position + character.last_character_direction * attack_point_offset

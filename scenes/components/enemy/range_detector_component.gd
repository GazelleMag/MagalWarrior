extends Area2D

#@export var movement_component: Node2D
@onready var character: CharacterBody2D = get_parent()
@onready var range_detector_collision_shape: CollisionShape2D = $CollisionShape2D
var player_in_range: bool = false
var range_detector_offset: float = 30.0

func update_player_range_detector(direction: Vector2) -> void:
	if direction != Vector2.ZERO:
		if abs(direction.x) > abs(direction.y):
			character.last_character_direction = Vector2(direction.x, 0).normalized()
		else:
			character.last_character_direction = Vector2(0, direction.y).normalized()
	update_range_detector_position()
	update_range_detector_rotation()

func update_range_detector_position() -> void:
	range_detector_collision_shape.global_position = global_position + character.last_character_direction * range_detector_offset

func update_range_detector_rotation() -> void:
	var angle = atan2(character.last_character_direction.y, character.last_character_direction.x)
	rotation_degrees = rad_to_deg(angle) + 90.0

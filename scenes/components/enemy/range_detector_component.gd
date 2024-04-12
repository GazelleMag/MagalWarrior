extends Area2D

@onready var range_detector_collision_shape: CollisionShape2D = $CollisionShape2D
@export var velocity_component: Node2D
@export var combat_component: Node2D
var player_in_range: bool = false
var range_detector_offset: float = 30.0

func _process(_delta: float) -> void:
	update_range_detector(velocity_component.character_direction)
	if player_in_range:
		combat_component.attack(velocity_component.character_direction)

func update_range_detector(direction: Vector2) -> void:
	if direction != Vector2.ZERO:
		if abs(direction.x) > abs(direction.y):
			velocity_component.last_character_direction = Vector2(direction.x, 0).normalized()
		else:
			velocity_component.last_character_direction = Vector2(0, direction.y).normalized()
	update_range_detector_position()
	update_range_detector_rotation()

func update_range_detector_position() -> void:
	range_detector_collision_shape.global_position = global_position + velocity_component.last_character_direction * range_detector_offset

func update_range_detector_rotation() -> void:
	var angle = atan2(velocity_component.last_character_direction.y, velocity_component.last_character_direction.x)
	rotation_degrees = rad_to_deg(angle) + 90.0

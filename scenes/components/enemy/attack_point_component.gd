extends Area2D

@onready var attack_point_collision_shape: CollisionShape2D = $CollisionShape2D
var attack_point_offset: float = 30.0
# components
@export var velocity_component: Node2D

func _process(_delta: float) -> void:
	update_attack_point_position(velocity_component.character_direction)

func update_attack_point_position(direction: Vector2) -> void:
	if direction != Vector2.ZERO:
		if abs(direction.x) > abs(direction.y):
			velocity_component.last_character_direction = Vector2(direction.x, 0).normalized()
		else:
			velocity_component.last_character_direction = Vector2(0, direction.y).normalized()
	attack_point_collision_shape.global_position = global_position + velocity_component.last_character_direction * attack_point_offset

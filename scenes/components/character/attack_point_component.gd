extends Area2D

@onready var attack_point_collision_shape: CollisionShape2D = $CollisionShape2D
var attack_point_offset: float = 30.0
# components
@export var velocity_component: Node2D

func _physics_process(_delta: float) -> void:
	update_attack_point_position()

func update_attack_point_position() -> void:
	attack_point_collision_shape.global_position = global_position + velocity_component.last_character_direction * attack_point_offset

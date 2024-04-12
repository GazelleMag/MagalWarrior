extends Node2D

@export var attack_point_component: Area2D
@export var animation_component: Node2D
var is_attacking: bool = false

func attack(direction: Vector2) -> void:
	is_attacking = true
	attack_point_component.attack_point_collision_shape.disabled = false
	animation_component.handle_attack_animation(direction)
	await animation_component.wait_for_attack_animation()
	attack_point_component.attack_point_collision_shape.disabled = true
	is_attacking = false

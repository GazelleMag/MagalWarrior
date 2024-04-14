extends Node2D

@onready var character: Node2D = get_parent()
var is_attacking: bool = false
@export var health_bar: ProgressBar
# components
@export var velocity_component: Node2D
@export var attack_point_component: Area2D
@export var animation_component: Node2D


signal health_changed

func _process(_delta: float) -> void:
	if !is_attacking:
		animation_component.handle_walk_animation(velocity_component.character_direction)

func attack(direction: Vector2) -> void:
	is_attacking = true
	attack_point_component.attack_point_collision_shape.disabled = false
	animation_component.handle_attack_animation(direction)
	await animation_component.wait_for_attack_animation()
	attack_point_component.attack_point_collision_shape.disabled = true
	is_attacking = false
	
func take_damage(damage: int) -> void:
	health_bar.update_health_bar(damage)
	if health_bar.currentHealth <= 0:
		character.die()
	
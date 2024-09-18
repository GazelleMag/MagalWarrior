extends Area2D

@onready var attack_point_collision_shape: CollisionShape2D = $CollisionShape2D
var attack_point_offset: float = 30.0
# components
@export var velocity_component: Node2D
@export var combat_component: Node2D

func _physics_process(_delta: float) -> void:
	update_attack_point_position()

func update_attack_point_position() -> void:
	attack_point_collision_shape.global_position = global_position + velocity_component.last_character_direction * attack_point_offset

# signals
func _on_attack_point_component_body_entered(body):
	if combat_component.melee_damage_inflicted == false:
		if body.name == "Player":
			body.take_damage(get_parent().enemy.damage)
			combat_component.melee_damage_inflicted = true
		elif body.is_in_group("Enemies"):
			body.take_damage(10)
			combat_component.melee_damage_inflicted = true

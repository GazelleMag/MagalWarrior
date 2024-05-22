extends Area2D

@onready var range_detector_collision_shape: CollisionShape2D = $CollisionShape2D
var player_in_range: bool = false
var range_detector_offset: float = 30.0
# components
@export var velocity_component: Node2D
@export var combat_component: Node2D

func _physics_process(_delta: float) -> void:
	update_range_detector()
		
func update_range_detector() -> void:
	update_range_detector_position()
	update_range_detector_rotation()

func update_range_detector_position() -> void:
	range_detector_collision_shape.global_position = global_position + velocity_component.last_character_direction * range_detector_offset

func update_range_detector_rotation() -> void:
	var angle: float = atan2(velocity_component.last_character_direction.y, velocity_component.last_character_direction.x)
	rotation_degrees = rad_to_deg(angle) + 90.0

# signals
func _on_body_entered(body):
	if body.name == "Player":
		player_in_range = true

func _on_body_exited(body):
	if body.name == "Player":
		player_in_range = false

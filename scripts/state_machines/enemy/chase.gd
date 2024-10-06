extends State
class_name Chase

@export var velocity_component: Node2D

func enter() -> void:
#	print("Entering chase state")
	pass

func physics_update(_delta: float) -> void:
	velocity_component.character_direction = velocity_component.calculate_chasing_direction()
	check_spawn_point_distance()
	if velocity_component.returning:
		transitioned.emit(self, "return")

func update(_delta: float) -> void:
	pass
		
func check_spawn_point_distance() -> void:
	var distance_to_spawn_point = velocity_component.global_position.distance_to(velocity_component.spawn_point_position)
	if distance_to_spawn_point > velocity_component.spawn_point_max_distance:
		velocity_component.chasing = false
		velocity_component.returning = true

extends State
class_name Return

@export var velocity_component: Node2D

func enter() -> void:
#	print("Entering return state")
	pass

func physics_update(_delta: float) -> void:
	velocity_component.character_direction = velocity_component.calculate_returning_direction()
	check_spawn_point_distance()
	if !velocity_component.chasing and !velocity_component.returning:
		velocity_component.character.reset_health()
		transitioned.emit(self, "idle")

func update(_delta: float) -> void:
	pass
	
func check_spawn_point_distance() -> void:
	var distance_to_spawn_point = velocity_component.global_position.distance_to(velocity_component.spawn_point_position)
	if distance_to_spawn_point <= velocity_component.spawn_point_distance_threshold:
		velocity_component.returning = false

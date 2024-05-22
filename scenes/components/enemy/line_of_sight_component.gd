extends RayCast2D

var raycast_length: int = 200
var player_on_sight: bool = false
# components
@export var velocity_component: Node2D

func _physics_process(_delta: float) -> void:
	update_line_of_sight_position()
	
func _process(_delta: float) -> void:
	if is_colliding():
		player_on_sight = true
	else:
		player_on_sight = false

func update_line_of_sight_position() -> void:
	var new_target_position: Vector2 = velocity_component.last_character_direction * raycast_length
	set_target_position(new_target_position)

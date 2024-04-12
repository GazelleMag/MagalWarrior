extends Node2D

@onready var character: Node2D = get_parent()
var speed: int = 175
var character_direction: Vector2
var last_character_direction: Vector2 = Vector2.DOWN
var last_character_direction_name: String = "down"
@onready var navigation_agent: NavigationAgent2D = $NavigationAgent2D
var chasing_player: bool = false
# spawn point
var spawn_point_position: Vector2
var back_to_spawn_point: bool = false
var spawn_point_max_distance: float = 400
var spawn_point_distance_threshold: float = 5

func _ready() -> void:
	spawn_point_position = character.spawn_point_position
	
func _process(_delta: float) -> void:
	check_spawn_point_distance()
	update_direction()
	
func check_spawn_point_distance() -> void:
	var distance_to_spawn_point = global_position.distance_to(spawn_point_position)
	if distance_to_spawn_point > spawn_point_max_distance:
		chasing_player = false
		back_to_spawn_point = true
	if distance_to_spawn_point <= spawn_point_distance_threshold:
		back_to_spawn_point = false
	
func update_direction() -> void:
	if chasing_player and !back_to_spawn_point:
		character_direction = to_local(navigation_agent.get_next_path_position()).normalized()
	elif !chasing_player and back_to_spawn_point:
		character_direction = (spawn_point_position - global_position).normalized()
	elif !chasing_player and !back_to_spawn_point:
		character_direction = Vector2.ZERO

func get_velocity() -> Vector2:
	return character_direction * speed

func _on_timer_timeout() -> void:
	makepath()

func makepath() -> void:
	navigation_agent.target_position = character.player.global_position

func chase_player() -> void:
	if !back_to_spawn_point:
		chasing_player = true

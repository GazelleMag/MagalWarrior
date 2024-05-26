extends Node2D

@onready var character: Node2D = get_parent()
@onready var navigation_agent: NavigationAgent2D = $NavigationAgent2D
var speed: int
var character_direction: Vector2
var last_character_direction: Vector2 = Vector2.DOWN
var last_character_direction_name: String = "down"
var chasing_player: bool = false
# spawn point
var spawn_point_position: Vector2
var back_to_spawn: bool = false
var spawn_point_max_distance: float = 600
var spawn_point_distance_threshold: float = 5
# separation force
var separation_radius: float = 60.0
var smoothing_factor: float = 0.5

func _ready() -> void:
	spawn_point_position = character.spawn_point_position

func _physics_process(_delta: float) -> void:
	update_direction()
	update_last_character_direction()

func _process(_delta: float) -> void:
	check_spawn_point_distance()
	
func check_spawn_point_distance() -> void:
	var distance_to_spawn_point = global_position.distance_to(spawn_point_position)
	if distance_to_spawn_point > spawn_point_max_distance:
		chasing_player = false
		back_to_spawn = true
		character.reset_health()
	if distance_to_spawn_point <= spawn_point_distance_threshold:
		back_to_spawn = false
	
func update_direction() -> void:
	if chasing_player:
		character_direction = calculate_chasing_direction()
	elif back_to_spawn:
		character_direction = calculate_back_to_spawn_direction()
	elif !chasing_player and !back_to_spawn:
		character_direction = Vector2.ZERO
		
func update_last_character_direction() -> void:
	if character_direction != Vector2.ZERO:
		if abs(character_direction.x) > abs(character_direction.y):
			last_character_direction = Vector2(character_direction.x, 0).normalized()
		else:
			last_character_direction = Vector2(0, character_direction.y).normalized()

func calculate_chasing_direction() -> Vector2:
	var next_position = navigation_agent.get_next_path_position()
	var direction_to_target = (next_position - global_position).normalized()
	var separation_force = calculate_separation_force()
	return (direction_to_target + separation_force).normalized()
	
func calculate_back_to_spawn_direction() -> Vector2:
	var next_position = navigation_agent.get_next_path_position()
	var direction_to_target = (next_position - global_position).normalized()
	return direction_to_target.normalized()
	
# this is to avoid enemies overlapping each other
func calculate_separation_force() -> Vector2:
	var separation_force = Vector2.ZERO
	var nearby_enemies = get_tree().get_nodes_in_group("Enemies")
	for enemy in nearby_enemies:
		if enemy != character:
			var distance = global_position.distance_to(enemy.global_position)
			if distance < separation_radius and distance > 0:
				var push_force = (global_position - enemy.global_position).normalized()
				separation_force += push_force
	return separation_force * smoothing_factor

func _on_timer_timeout() -> void:
	make_path()

func make_path() -> void:
	if is_instance_valid(character.player) and chasing_player:
		navigation_agent.target_position = character.player.global_position
	elif back_to_spawn:
		navigation_agent.target_position = spawn_point_position

func get_velocity() -> Vector2:
	return character_direction * speed

func chase_player() -> void:
	if !back_to_spawn:
		chasing_player = true

extends Node2D

@onready var character: Node2D = get_parent()
@onready var navigation_agent: NavigationAgent2D = $NavigationAgent2D
@onready var state_machine: Node = $StateMachine
var speed: int
var character_direction: Vector2
var last_character_direction: Vector2 = Vector2.DOWN
var last_character_direction_name: String = "down"
var stopping_distance: float = 50.0 # to stop chasing if it's already close
# spawn point
var spawn_point_position: Vector2
var spawn_point_max_distance: float = 600
var spawn_point_distance_threshold: float = 5
# separation force
var separation_radius: float = 60.0
var smoothing_factor: float = 0.5
# state conditions
var chasing: bool = false
var returning: bool = false
# for testing purposes
var sentry_mode = false

func _ready() -> void:
	spawn_point_position = character.spawn_point_position

func _physics_process(_delta: float) -> void:
	update_last_character_direction()
		
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
	
func calculate_returning_direction() -> Vector2:
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
	if sentry_mode:
		navigation_agent.velocity = Vector2.ZERO
		return
		
	if is_instance_valid(character.player) and chasing:
		navigation_agent.target_position = character.player.global_position
	elif !is_instance_valid(character.player) or returning:
		navigation_agent.target_position = spawn_point_position

func handle_movement() -> void:
	if is_instance_valid(character.player):
		var distance_to_player: float = global_position.distance_to(character.player.global_position)
		if distance_to_player < stopping_distance:
			character.velocity = Vector2.ZERO
		else:
			character.velocity = get_velocity()
	else:
		character.velocity = get_velocity()

func get_velocity() -> Vector2:
	return character_direction * speed

func chase_player() -> void:
	if !returning:
		chasing = true

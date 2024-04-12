extends Node2D

@onready var character: Node2D = get_parent()
var speed: int = 175
var character_direction: Vector2
var last_character_direction: Vector2 = Vector2.DOWN
var last_character_direction_name: String = "down"
@onready var nav_agent: NavigationAgent2D = $NavigationAgent2D
var chasing_player: bool = false
var spawn_point_position: Vector2
var back_to_spawn_point: bool = false

# func update_movement() -> void:
#	handle_direction()
#	handle_movement()

func _ready() -> void:
	spawn_point_position = character.spawn_point_position
	
func _process(_delta: float) -> void:
	update_direction()
	
func update_direction() -> void:
	if chasing_player and !back_to_spawn_point:
		character_direction = to_local(nav_agent.get_next_path_position()).normalized()
	elif !chasing_player and back_to_spawn_point:
		character_direction = (spawn_point_position - global_position).normalized()
	elif !chasing_player and !back_to_spawn_point:
		character_direction = Vector2.ZERO

func get_velocity() -> Vector2:
	return character_direction * speed

# func handle_movement() -> void:
# 	velocity = character_direction * speed
# 	move_and_slide()

func _on_timer_timeout() -> void:
	makepath()

func makepath() -> void:
	nav_agent.target_position = character.player.global_position

func start_chasing_player() -> void:
	if !back_to_spawn_point:
		chasing_player = true

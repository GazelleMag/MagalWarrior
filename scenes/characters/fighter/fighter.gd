extends CharacterBody2D

var character_name: String
@onready var player: Node2D = $"../Player"
# spawn point
var spawn_point_position: Vector2
var spawn_point_max_distance: float = 400
var spawn_point_distance_threshold: float = 5
# movement
var speed: int = 175
var character_direction: Vector2
var last_character_direction: Vector2 = Vector2.DOWN
var last_character_direction_name: String = "down"
@onready var nav_agent: NavigationAgent2D = $NavigationAgent2D
var chasing_player: bool = false
var back_to_spawn_point: bool = false
# status
var maxHealth: int = 100
@onready var currentHealth: int = maxHealth
# components
#@onready var movement_component: Node2D = $MovementComponent
#@onready var animation_component: Node2D = $AnimationComponent
#@onready var range_detector_component: Area2D = $RangeDetectorComponent
#@onready var attack_point_component: Area2D = $AttackPointComponent
#@onready var combat_component: Node2D = $CombatComponent

#@export var movement_component: Node2D
@export var animation_component: Node2D
@export var range_detector_component: Area2D
@export var attack_point_component: Area2D
@export var combat_component: Node2D

signal health_changed

func _ready() -> void:
	health_changed.emit()

func _process(_delta: float) -> void:
	# spawn point
	check_spawn_point_distance()
	# movement
	handle_direction()
	handle_movement()
	# attack_point
	attack_point_component.update_attack_point_position(character_direction)
	# player in range detector
	range_detector_component.update_player_range_detector(character_direction)
	# animations
	if !combat_component.is_attacking:
		animation_component.handle_walk_animation(character_direction)
	if range_detector_component.player_in_range:
		combat_component.attack(character_direction)

func handle_direction() -> void:
	if chasing_player and !back_to_spawn_point:
		character_direction = to_local(nav_agent.get_next_path_position()).normalized()
	elif !chasing_player and back_to_spawn_point:
		character_direction = (spawn_point_position - global_position).normalized()
	elif !chasing_player and !back_to_spawn_point:
		character_direction = Vector2.ZERO

func handle_movement() -> void:
	velocity = character_direction * speed
	move_and_slide()
	
func _on_timer_timeout() -> void: # THIS SIGNAL WAS NOT SET ON MOVEMENT COMPONENT
	makepath()

func makepath() -> void:
	nav_agent.target_position = player.global_position

func start_chasing_player() -> void:
	if !back_to_spawn_point:
		chasing_player = true

# spawn point
func set_spawn_point(spawn_point: Node2D) -> void:
	spawn_point_position = spawn_point.global_position

func check_spawn_point_distance() -> void:
	var distance_to_spawn_point = global_position.distance_to(spawn_point_position)
	if distance_to_spawn_point > spawn_point_max_distance:
		chasing_player = false
		back_to_spawn_point = true
	if distance_to_spawn_point <= spawn_point_distance_threshold:
		back_to_spawn_point = false

func take_damage(damage: int) -> void:
	currentHealth = currentHealth - damage
	health_changed.emit()
	if currentHealth <= 0:
		die()
	
func die() -> void:
	queue_free()

# signals
func _on_attack_point_component_body_entered(body: Node2D):
	if body.name == "Player":
		body.take_damage()

func _on_range_detector_component_body_entered(body: Node2D):
	if body.name == "Player":
		range_detector_component.player_in_range = true

func _on_range_detector_component_body_exited(body: Node2D):
	if body.name == "Player":
		range_detector_component.player_in_range = false

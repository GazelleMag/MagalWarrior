extends Node2D

var character_name: String
@onready var player: Node2D = $"../Player"
# spawn point
var spawn_point_position: Vector2
var spawn_point_max_distance: float = 400
var spawn_point_distance_threshold: float = 5
# status
var maxHealth: int = 100
@onready var currentHealth: int = maxHealth
# components
@onready var movement_component: CharacterBody2D = $MovementComponent
@onready var animation_component: Node2D = $AnimationComponent
@onready var range_detector_component: Area2D = $RangeDetectorComponent
@onready var attack_point_component: Area2D = $AttackPointComponent
@onready var combat_component: Node2D = $CombatComponent

signal health_changed

func _ready() -> void:
	health_changed.emit()

func _process(_delta: float) -> void:
	# spawn point
	check_spawn_point_distance()
	# movement
	movement_component.update_movement()
	# attack_point
	attack_point_component.update_attack_point_position(movement_component.character_direction)
	# player in range detector
	range_detector_component.update_player_range_detector(movement_component.character_direction)
	# animations
	if !combat_component.is_attacking:
		animation_component.handle_walk_animation(movement_component.character_direction)
	if range_detector_component.player_in_range:
		combat_component.attack(movement_component.character_direction)
	
# spawn point
func set_spawn_point(spawn_point: Node2D) -> void:
	spawn_point_position = spawn_point.global_position
	# this should only be set in the movement component
	movement_component.spawn_point_position = spawn_point_position

func check_spawn_point_distance() -> void:
	var distance_to_spawn_point = global_position.distance_to(spawn_point_position)
	if distance_to_spawn_point > spawn_point_max_distance:
		movement_component.chasing_player = false
		movement_component.back_to_spawn_point = true
	if distance_to_spawn_point <= spawn_point_distance_threshold:
		movement_component.back_to_spawn_point = false

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

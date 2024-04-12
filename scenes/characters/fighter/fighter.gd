extends CharacterBody2D

var character_name: String
@onready var player: Node2D = $"../Player"
# spawn point
var spawn_point_position: Vector2
# status
var maxHealth: int = 100
@onready var currentHealth: int = maxHealth
# components
@export var velocity_component: Node2D
@export var range_detector_component: Area2D
@export var animation_component: Node2D

signal health_changed

func _ready() -> void:
	health_changed.emit()
	set_character_animation()

func _process(_delta: float) -> void:
	handle_movement()

func set_character_animation() -> void:
	for child in get_children():
		if child is AnimatedSprite2D:
			animation_component.character_animation = child

func handle_movement() -> void:
	velocity = velocity_component.get_velocity()
	move_and_slide()

func chase_player() -> void:
	velocity_component.chase_player()

# this could go into combat component
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

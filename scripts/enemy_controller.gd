extends CharacterBody2D

@onready var player: Node2D = $"../Player"
var character_name: String
var spawn_point_position: Vector2
var enemy: Enemy
# components
@export var velocity_component: Node2D
@export var range_detector_component: Area2D
@export var animation_component: Node2D
@export var combat_component: Node2D
@export var health_bar: ProgressBar

func _ready() -> void:
	enemy = Enemy.new(character_name)
	set_character_properties()
	set_character_animation()

func _process(_delta: float) -> void:
	handle_movement()

func set_character_animation() -> void:
	for child in get_children():
		if child is AnimatedSprite2D:
			animation_component.character_animation = child
			
func set_character_properties() -> void:
	velocity_component.speed = enemy.movement_speed
	health_bar.max_health = enemy.max_health
	health_bar.current_health = health_bar.max_health

func handle_movement() -> void:
	velocity = velocity_component.get_velocity()
	move_and_slide()

func chase_player() -> void:
	velocity_component.chase_player()

func take_damage(damage: int) -> void:
	combat_component.take_damage(damage)
	
func die() -> void:
	queue_free()

# signals
func _on_attack_point_component_body_entered(body: Node2D):
	if body.name == "Player":
		body.take_damage(enemy.attack_damage)

func _on_range_detector_component_body_entered(body: Node2D):
	if body.name == "Player":
		range_detector_component.player_in_range = true

func _on_range_detector_component_body_exited(body: Node2D):
	if body.name == "Player":
		range_detector_component.player_in_range = false

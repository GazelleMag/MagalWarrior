extends CharacterBody2D

@onready var level: Node2D = get_parent()
@onready var UI: CanvasLayer = $"../UI"
@onready var player_animation: AnimatedSprite2D = $PlayerAnimation
@onready var death_animation: AnimatedSprite2D = $DeathAnimation
# components
@export var velocity_component: Node2D
@export var animation_component: Node2D
@export var attack_point_component: Area2D
@export var combat_component: Node2D
@export var health_component: Node2D
@export var audio_component: Node2D

signal health_changed
signal key_use
signal player_died

func _ready() -> void:
	set_player_properties()
	UI.set_ability_action_bar(combat_component.abilities)

func _physics_process(_delta: float) -> void:
	handle_movement(velocity_component.character_direction)
	
func _process(delta: float) -> void:
	audio_component.play_footstep(delta, velocity)

func set_player_properties() -> void:
	# property values below should probably go into a 'player' class
	velocity_component.speed = 250
	health_component.max_health = 100
	health_component.current_health = health_component.max_health

# movement
func handle_movement(direction: Vector2) -> void:
	velocity = direction * velocity_component.speed
	move_and_slide()

# below functions are bad code, signal should emit from health component
func take_damage(damage: int) -> void:
	combat_component.take_damage(damage)
	health_changed.emit() # this updates UI health bar
	
func heal(heal_amount: int) -> void:
	combat_component.heal(heal_amount)
	health_changed.emit() # this updates UI health bar

func handle_cooldown(cooldown_status, key: String) -> void:
	combat_component.handle_cooldown(cooldown_status, key)
	
func die() -> void:
	set_physics_process(false)
	animation_component.handle_death_animation()
	await animation_component.wait_for_death_animation()
	player_died.emit()
	queue_free()
	
func emit_key_use_signal(key: String) -> void:
	emit_signal("key_use", key)

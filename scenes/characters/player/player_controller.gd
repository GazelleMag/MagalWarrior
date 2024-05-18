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

signal health_changed
signal mouse_click
signal player_died

func _ready() -> void:
	set_player_properties()
	UI.set_ability_action_bar(combat_component.abilities)
	
func _process(_delta) -> void:
	handle_movement(velocity_component.character_direction)

func set_player_properties() -> void:
	# property values below should probably go into a 'player' class
	velocity_component.speed = 250
	health_component.max_health = 100
	health_component.current_health = health_component.max_health

# movement
func handle_movement(direction: Vector2) -> void:
	velocity = direction * velocity_component.speed
	move_and_slide()
#
func take_damage(damage: int) -> void:
	combat_component.take_damage(damage)
	health_changed.emit() # this updates UI health bar

func handle_mouse_cooldown(cooldown_status: bool, click_type: String):
	combat_component.handle_mouse_cooldown(cooldown_status, click_type)	

func die() -> void:
	set_process(false)
	animation_component.handle_death_animation()
	await animation_component.wait_for_death_animation()
	player_died.emit()
	queue_free()

func emit_mouse_click_signal(click_type: String) -> void:
	emit_signal("mouse_click", click_type)

func _on_attack_point_component_body_entered(body: Node2D):
	if body.is_in_group("Enemies") and combat_component.melee_damage_inflicted == false:
		body.take_damage(10)
		combat_component.melee_damage_inflicted = true

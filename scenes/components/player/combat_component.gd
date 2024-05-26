extends Node2D

@onready var character: CharacterBody2D = get_parent()
var is_attacking: bool = false
var melee_damage_inflicted: bool = false
var is_casting_fireball: bool = false
var mouse1_cooldown: bool = false
var mouse2_cooldown: bool = false
var abilities: Array[String] = [
	"basic_attack",
	"fireball"
]
# components
@export var velocity_component: Node2D
@export var attack_point_component: Area2D
@export var animation_component: Node2D
@export var health_component: Node2D

var fireball_scene = preload("res://scenes/abilities/fireball.tscn")
var fireball_speed: int = 300

func _process(_delta: float) -> void:
	if !is_attacking:
		animation_component.handle_walk_animation(velocity_component.character_direction)
	if Input.is_action_just_pressed("mouse1") and !is_attacking and !mouse1_cooldown:
		mouse1_cooldown = true
		character.emit_mouse_click_signal("mouse1")
		attack(velocity_component.character_direction)
	if Input.is_action_just_pressed("mouse2") and !mouse2_cooldown:
		mouse2_cooldown = true
		character.emit_mouse_click_signal("mouse2")
		cast_fireball()

func attack(direction: Vector2) -> void:
	is_attacking = true
	melee_damage_inflicted = false
	attack_point_component.attack_point_collision_shape.disabled = false
	animation_component.handle_attack_animation(direction)
	await animation_component.wait_for_animation()
	is_attacking = false
	
func cast_fireball() -> void:
	is_casting_fireball = true
	var fireball = fireball_scene.instantiate()
	fireball.set_projectile_area_mask(character.name)
	fireball.position = attack_point_component.global_position
	fireball.linear_velocity = velocity_component.last_character_direction * fireball_speed
	fireball.handle_projectile_orientation(velocity_component.last_character_direction)
	character.level.add_child(fireball)

func take_damage(damage: int) -> void:
	health_component.update_health(-damage)
	if health_component.current_health <= 0:
		character.die()
		
func heal(heal_amount: int) -> void:
	health_component.update_health(heal_amount)
	if health_component.current_health > health_component.max_health:
		health_component.current_health = health_component.max_health

func handle_mouse_cooldown(cooldown_status: bool, click_type: String):
	if click_type == "mouse1":
		mouse1_cooldown = cooldown_status
	elif click_type == "mouse2":
		mouse2_cooldown = cooldown_status

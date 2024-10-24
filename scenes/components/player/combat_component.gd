extends Node2D

@onready var character: CharacterBody2D = get_parent()
var is_attacking: bool = false
var melee_damage_inflicted: bool = false
var melee_attack_direction: Vector2 = Vector2.ZERO
var is_casting_fireball: bool = false
var mouse1_cooldown: bool = false
var mouse2_cooldown: bool = false
@export var ability_names: Array[String]
var abilities: Array[Ability]
# components
@export var velocity_component: Node2D
@export var attack_point_component: Area2D
@export var animation_component: Node2D
@export var health_component: Node2D
@export var audio_component: Node2D

var projectile_scene = preload("res://scenes/abilities/projectile.tscn")

func _ready() -> void:
	set_player_abilities()

func _process(_delta: float) -> void:
	if !is_attacking:
		animation_component.handle_walk_animation(velocity_component.character_direction)
	if Input.is_action_just_pressed("mouse1") and !is_attacking and !mouse1_cooldown:
		mouse1_cooldown = true
		character.emit_mouse_click_signal("mouse1")
		attack(velocity_component.character_direction) # this should be some kind of primary action
		# play sound
		audio_component.play_weapon_sound()
		
	if Input.is_action_just_pressed("mouse2") and !mouse2_cooldown:
		mouse2_cooldown = true
		character.emit_mouse_click_signal("mouse2")
		cast_projectile(abilities[1]) # this might not be a projectile

func set_player_abilities() -> void:
	if ability_names.size() == 0:
		return
	else:
		for ability_name in ability_names:
			var ability: Ability = Ability.new(ability_name)
			abilities.append(ability)

func attack(direction: Vector2) -> void:
	is_attacking = true
	melee_damage_inflicted = false
	melee_attack_direction = velocity_component.last_character_direction
	attack_point_component.attack_point_collision_shape.disabled = false
	animation_component.handle_attack_animation(direction)
	await animation_component.wait_for_animation()
	is_attacking = false

func cast_projectile(projectile: Ability) -> void:
	is_casting_fireball = true
	var new_projectile = projectile_scene.instantiate()
	new_projectile.projectile_name = projectile.name
	new_projectile.set_projectile_area_mask(character.name)
	new_projectile.position = attack_point_component.global_position
	new_projectile.linear_velocity = velocity_component.last_character_direction * projectile.speed
	new_projectile.handle_projectile_orientation(velocity_component.last_character_direction)
	character.level.add_child(new_projectile)

func take_damage(damage: int) -> void:
	animation_component.flash_red()
	audio_component.play_hit_sound()
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

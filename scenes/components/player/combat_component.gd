extends Node2D

@onready var character: CharacterBody2D = get_parent()
var is_attacking: bool = false
var melee_damage_inflicted: bool = false
var melee_attack_direction: Vector2 = Vector2.ZERO
@export var ability_names: Array[String]
var abilities: Array[Ability]
var cooldowns = { "mouse1": false, "mouse2": false, "q": false }
# overtime heal
var heal_timer: Timer
var is_healing: bool = false
var heal_duration: float= 3.0
var heal_interval: float = 0.5
@export var flourish_particles: CPUParticles2D
# components
@export var velocity_component: Node2D
@export var attack_point_component: Area2D
@export var animation_component: Node2D
@export var health_component: Node2D
@export var audio_component: Node2D

var projectile_scene = preload("res://scenes/abilities/projectile.tscn")

func _ready() -> void:
	set_player_abilities()
	set_heal_over_time()

func _process(_delta: float) -> void:
	if !is_attacking:
		animation_component.handle_walk_animation(velocity_component.character_direction)
	if Input.is_action_just_pressed("mouse1") and !cooldowns["mouse1"]:
		cooldowns["mouse1"] = true
		character.emit_key_use_signal("mouse1")
		attack(velocity_component.character_direction) # this should be some kind of primary action
		audio_component.play_weapon_sound()
	if Input.is_action_just_pressed("mouse2") and !cooldowns["mouse2"]:
		cooldowns["mouse2"] = true
		character.emit_key_use_signal("mouse2")
		cast_projectile(abilities[1]) # this might not be a projectile
	if Input.is_action_just_pressed("q") and !cooldowns["q"]:
		cooldowns["q"] = true
		character.emit_key_use_signal("q")
		cast_heal_over_time() # this might not be a heal

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

func set_heal_over_time() -> void:
	heal_timer = Timer.new()
	heal_timer.wait_time = heal_interval
	heal_timer.one_shot = false
	heal_timer.connect("timeout", _on_heal_tick)
	add_child(heal_timer)

func cast_heal_over_time() -> void:
	animation_component.flash_green()
	is_healing = true
	flourish_particles.emitting = true
	heal_timer.start()
	await get_tree().create_timer(heal_duration).timeout
	stop_heal_over_time()
	
func stop_heal_over_time() -> void:
	is_healing = false
	flourish_particles.emitting = false
	heal_timer.stop()

func handle_cooldown(cooldown_status: bool, key: String) -> void:
	cooldowns[key] = cooldown_status

# signals
func _on_heal_tick() -> void:
	if health_component.current_health < health_component.max_health:
		character.heal(abilities[2].heal_amount)

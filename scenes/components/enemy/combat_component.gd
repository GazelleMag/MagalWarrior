extends Node2D

@onready var character: CharacterBody2D = get_parent()
var executing_ability: bool = false
@export var health_bar: ProgressBar
@export var ability_names: Array[String]
var abilities: Array[Ability]
var ability_cooldown_timers: Dictionary = {}
# components
@export var velocity_component: Node2D
@export var attack_point_component: Area2D
@export var animation_component: Node2D
@export var health_component: Node2D

func _ready() -> void:
	set_character_abilities()

func _process(_delta: float) -> void:
	if !executing_ability:
		animation_component.handle_walk_animation(velocity_component.character_direction)

func set_character_abilities() -> void:
	if ability_names.size() == 0:
		return
	else:
		for ability_name in ability_names:
			var ability = Ability.new(ability_name)
			abilities.append(ability)
			set_ability_cooldown_timer(ability)
			
func set_ability_cooldown_timer(ability: Ability) -> void:
	var cooldown_timer = Timer.new()
	cooldown_timer.wait_time = ability.cooldown_time
	cooldown_timer.one_shot = true
	add_child(cooldown_timer)
	ability_cooldown_timers[ability] = cooldown_timer

# this function decides what ability the character should use
func execute_ability(direction: Vector2) -> void:
	execute_primary_ability(direction)

func execute_primary_ability(direction: Vector2) -> void:
	var ability = abilities[0]
	var cooldown_timer = ability_cooldown_timers[ability]
	if ability != null:
		if cooldown_timer.time_left > 0:
			return
		if ability.type == "melee":
			melee_attack(direction)
		elif ability.type == "ranged":
			ranged_attack(direction)
	cooldown_timer.start()
	
func execute_secondary_ability(_direction: Vector2) -> void:
	var ability = abilities[1]
	if ability != null:
		# TODO
		pass
	
func execute_defensive_ability(_direction: Vector2) -> void:
	var ability = abilities[2]
	if ability != null:
		# TODO
		pass
	
func melee_attack(direction: Vector2) -> void:
	executing_ability = true
	attack_point_component.attack_point_collision_shape.disabled = false
	animation_component.handle_attack_animation(direction)
	await animation_component.wait_for_animation()
	attack_point_component.attack_point_collision_shape.disabled = true
	executing_ability = false
	
func ranged_attack(_direction: Vector2) -> void:
	# TODO
	pass

func take_damage(damage: int) -> void:
	health_component.update_health(damage)
	health_bar.update_health_bar()
	if health_component.current_health <= 0:
		character.die()

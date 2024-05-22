extends Node2D

@onready var character: CharacterBody2D = get_parent()
var executing_ability: bool = false
var melee_damage_inflicted: bool = false
@export var health_bar: ProgressBar
@export var ability_names: Array[String]
var abilities: Array[Ability]
var ability_cooldown_timers: Dictionary = {}
var has_melee_ability: bool = false
var has_ranged_ability: bool = false
# components
@export var velocity_component: Node2D
@export var attack_point_component: Area2D
@export var animation_component: Node2D
@export var line_of_sight_component: RayCast2D

func _ready() -> void:
	set_character_abilities()
	has_melee_ability = check_abilities("melee")
	has_ranged_ability = check_abilities("ranged")

func _process(_delta: float) -> void:
	if !executing_ability:
		animation_component.handle_walk_animation(velocity_component.character_direction)

func set_character_abilities() -> void:
	if ability_names.size() == 0:
		return
	else:
		for ability_name in ability_names:
			var ability: Ability = Ability.new(ability_name)
			abilities.append(ability)
			set_ability_cooldown_timer(ability)
			
func set_ability_cooldown_timer(ability: Ability) -> void:
	var cooldown_timer: Timer = Timer.new()
	cooldown_timer.wait_time = ability.cooldown_time
	cooldown_timer.one_shot = true
	add_child(cooldown_timer)
	ability_cooldown_timers[ability] = cooldown_timer
			
func check_abilities(ability_type: String) -> bool:
	for ability in abilities:
		if ability.type == ability_type:
			return true
	return false
			
func use_ability(ability_type: String) -> void:
	if abilities.size() == 0:
		return
	if ability_type == "melee" and has_melee_ability == false:
		return
	elif ability_type == "ranged" and has_ranged_ability == false:
		return
	# look for available abilities
	var ability_indexes: Array[int] = []
	for i in range(len(abilities)):
		if abilities[i].type == ability_type:
			ability_indexes.append(i)
	# if there's only one ability of the given type, execute that one:
	if ability_indexes.size() == 1:
		execute_ability(ability_indexes[0])
	elif ability_indexes.size() > 1:
		# calculate weights
		var weights_result: Array = calculate_ability_weights(ability_indexes)
		var total_weight: int = weights_result[0]
		var weights: Array[int] = weights_result[1]
		# choose ability based on weights_indexes[i]
		choose_ability(ability_indexes, total_weight, weights)
		
func calculate_ability_weights(ability_indexes: Array[int]) -> Array:
	var total_weight: int = 0
	var weights: Array[int] = []
	for i in range(ability_indexes.size()):
			var weight: int = ability_indexes.size() - i
			weights.append(weight)
			total_weight += weight
	return [total_weight, weights]

func choose_ability(ability_indexes: Array[int], total_weight: int, weights: Array[int]) -> void:
	var random_value: int = randi() % total_weight
	var cumulative_weight: int = 0
	for i in range(ability_indexes.size()):
		cumulative_weight += weights[i]
		if random_value < cumulative_weight:
			execute_ability(ability_indexes[i])

func execute_ability(ability_index: int) -> void:
	var ability: Ability = abilities[ability_index]
	var cooldown_timer: Timer = ability_cooldown_timers[ability]
	if ability != null:
		if cooldown_timer.time_left > 0:
			return
		if ability.type == "melee":
			melee_attack()
		elif ability.type == "ranged":
			ranged_attack(ability)
	cooldown_timer.start()
	
func melee_attack() -> void:
	executing_ability = true
	melee_damage_inflicted = false
	attack_point_component.attack_point_collision_shape.disabled = false
	animation_component.handle_attack_animation(velocity_component.last_character_direction)
	await animation_component.wait_for_animation()
	executing_ability = false
	
func ranged_attack(ability: Ability) -> void:
	var projectile_scene: PackedScene = load("res://scenes/abilities/" + ability.name + ".tscn")
	var projectile: RigidBody2D = projectile_scene.instantiate()
	projectile.set_projectile_area_mask(character.name)
	projectile.position = attack_point_component.global_position
	projectile.linear_velocity = velocity_component.last_character_direction * ability.speed
	projectile.handle_projectile_orientation(velocity_component.last_character_direction)
	character.level.add_child(projectile)

extends CharacterBody2D

@onready var level: Node2D = get_parent()
@onready var player: Node2D = $"../Player"
@onready var collision_shape: CollisionShape2D = $CollisionShape2D
var character_name: String
var spawn_point_position: Vector2
var enemy: Enemy
# components
@export var velocity_component: Node2D
@export var range_detector_component: Area2D
@export var animation_component: Node2D
@export var combat_component: Node2D
@export var health_component: Node2D
@export var line_of_sight_component: RayCast2D
@export var audio_component: Node2D

signal defeated

func _ready() -> void:
	enemy = Enemy.new(character_name)
	set_character_properties()

func _physics_process(_delta: float) -> void:
	handle_movement()

func _process(delta: float) -> void:
	audio_component.play_footstep(delta, velocity)
	if range_detector_component.player_in_range == true:
		# this should be only a melee ability
		combat_component.use_ability("melee")
	if line_of_sight_component.player_on_sight == true:
		# this should be only a ranged ability
		combat_component.use_ability("ranged")
		
func set_character_properties() -> void:
	velocity_component.speed = enemy.speed
	health_component.max_health = enemy.health
	health_component.current_health = health_component.max_health
	combat_component.ability_names = enemy.abilities
	combat_component.call_deferred("set_character_abilities")
	combat_component.call_deferred("check_abilities", "melee")
	combat_component.call_deferred("check_abilities", "ranged")

func handle_movement() -> void:
	velocity = velocity_component.get_velocity()
	move_and_slide()

func chase_player() -> void:
	velocity_component.chase_player()
	
func take_damage(damage: int) -> void:
	if !velocity_component.back_to_spawn:
		health_component.update_health(damage)
		if health_component.current_health <= 0:
			die()
	
func reset_health() -> void:
	health_component.reset_health()
	
func die() -> void:
	set_physics_process(false)
	health_component.health_bar.visible = false
	call_deferred("disable_collision_shape")
	animation_component.handle_death_animation()
	await animation_component.wait_for_death_animation()
	emit_signal("defeated")
	queue_free()

func disable_collision_shape() -> void:
	collision_shape.disabled = true

extends CharacterBody2D

const speed: int = 250
var last_direction: Vector2 = Vector2.DOWN
var last_direction_name: String = "down"
@onready var player_animation: AnimatedSprite2D = $PlayerAnimation

var is_attacking: bool = false
var is_casting_fireball: bool = false
var mouse1_cooldown: bool = false
var mouse2_cooldown: bool = false
@onready var attack_point: Area2D = $AttackPoint
@onready var attack_point_collision_shape: CollisionShape2D = $AttackPoint/CollisionShape2D
var attack_point_offset: float = 30.0

var maxHealth: int = 100
@onready var currentHealth: int = maxHealth

var fireball_scene = preload("res://scenes/abilities/fireball.tscn")
var fireball_speed: int = 300

signal health_changed
signal mouse_click

func _process(_delta) -> void:
	# movement
	var direction = Input.get_vector("left", "right", "up", "down")
	handle_movement(direction)
	# attack point
	update_attack_point_position(direction)
	# animations
	if !is_attacking:
		handle_walk_animation(direction)
	if Input.is_action_just_pressed("mouse1") and !is_attacking and !mouse1_cooldown:
		mouse1_cooldown = true
		emit_signal("mouse_click", "mouse1")
		attack(direction)
	if Input.is_action_just_pressed("mouse2") and !mouse2_cooldown:
		mouse2_cooldown = true
		emit_signal("mouse_click", "mouse2")
		cast_fireball()
	

# movement
func handle_movement(direction: Vector2) -> void:
	velocity = direction * speed
	move_and_slide()

# animations
func handle_walk_animation(direction: Vector2) -> void:
	if direction != Vector2.ZERO:
		if abs(direction.x) > abs(direction.y):
			if direction.x > 0:
				player_animation.play("walk_right")
				last_direction_name = "right"
			else:
				player_animation.play("walk_left")
				last_direction_name = "left"
		else:
			if direction.y > 0:
				player_animation.play("walk_down")
				last_direction_name = "down"
			else:
				player_animation.play("walk_up")
				last_direction_name = "up"
	else:
		if last_direction_name != "":
			player_animation.play("idle_" + last_direction_name)

func handle_attack_animation(direction: Vector2) -> void:
	if direction != Vector2.ZERO:
		if abs(direction.x) > abs(direction.y):
			if direction.x > 0:
				player_animation.play("attack_right")
			else:
				player_animation.play("attack_left")
		else:
			if direction.y > 0:
				player_animation.play("attack_down")
			else:
				player_animation.play("attack_up")
	else:
		if last_direction_name != "":
			player_animation.play("attack_" + last_direction_name)

func wait_for_animation() -> void:
	await player_animation.animation_finished

# combat
func update_attack_point_position(direction: Vector2) -> void:
	if direction != Vector2.ZERO:
		if abs(direction.x) > abs(direction.y):
			last_direction = Vector2(direction.x, 0).normalized()
		else:
			last_direction = Vector2(0, direction.y).normalized()
	attack_point.global_position = global_position + last_direction * attack_point_offset
	attack_point_collision_shape.global_position = attack_point.global_position

func attack(direction: Vector2) -> void:
	attack_point_collision_shape.disabled = false
	is_attacking = true
	handle_attack_animation(direction)
	await wait_for_animation()
	attack_point_collision_shape.disabled = true

func cast_fireball() -> void:
	is_casting_fireball = true
	var fireball = fireball_scene.instantiate()
	fireball.position = attack_point.global_position
	fireball.linear_velocity = last_direction * fireball_speed
	fireball.handle_fireball_orientation(last_direction)
	get_parent().add_child(fireball)

func take_damage() -> void:
	currentHealth = currentHealth - 10
	health_changed.emit()
	
# signals
func _on_player_animation_animation_finished():
	is_attacking = false

func _on_area_2d_body_entered(body: Node2D):
	if(body.name == "Fighter"):
		body.take_damage(10) # basic attack damage

extends CharacterBody2D

const speed: int = 250
var last_direction: Vector2 = Vector2.DOWN
var last_direction_name: String = "down"
var player_animation: AnimatedSprite2D
var attack_animations: Array = ["attack_up", "attack_down", "attack_left", "attack_right"]
var is_attacking: bool = false

var attack_point: Area2D
var attack_point_collider: CollisionShape2D
var attack_point_offset: float = 30.0

var maxHealth: int = 100
@onready var currentHealth: int = maxHealth

signal health_changed

func _ready() -> void:
	player_animation = $PlayerAnimation
	attack_point = $AttackPoint
	attack_point_collider = $AttackPoint/CollisionShape2D

func _process(_delta) -> void:
	# movement
	var direction = Input.get_vector("left", "right", "up", "down")
	handle_movement(direction)
	# animations
	if !is_attacking:
		handle_walk_animation(direction)
	if Input.is_action_just_pressed("mouse1") and !is_attacking:
		attack_point_collider.disabled = false
		is_attacking = true
		handle_attack_animation(direction)
		await wait_for_attack_animation()
		attack_point_collider.disabled = true
	# attack point
	update_attack_point_position(direction)

func handle_movement(direction: Vector2) -> void:
	velocity = direction * speed
	move_and_slide()

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

func update_attack_point_position(direction: Vector2) -> void:
	if direction != Vector2.ZERO:
		if abs(direction.x) > abs(direction.y):
			last_direction = Vector2(direction.x, 0).normalized()
		else:
			last_direction = Vector2(0, direction.y).normalized()
		attack_point_collider.global_position = attack_point.global_position + last_direction * attack_point_offset
	else:
		attack_point_collider.global_position = attack_point.global_position + last_direction * attack_point_offset

func wait_for_attack_animation():
	await player_animation.animation_finished

func take_damage() -> void:
	currentHealth = currentHealth - 10
	health_changed.emit()

# signals
func _on_player_animation_animation_finished():
	is_attacking = false

func _on_area_2d_body_entered(body):
	if(body.name == "Fighter"):
		body.take_damage()

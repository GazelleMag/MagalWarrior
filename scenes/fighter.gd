extends CharacterBody2D

const speed: int = 175
var last_direction: Vector2 = Vector2.DOWN
var last_direction_name: String = "down"
var nav_agent: NavigationAgent2D
var fighter_animation: AnimatedSprite2D
var player: Node2D

var is_attacking: bool = false
var detecting_player: bool = false
var attack_point: Area2D
var attack_point_collision_shape: CollisionShape2D
var attack_point_offset: float = 30.0
var player_detected: bool = false
var player_detector: Area2D
var player_detector_collision_shape: CollisionShape2D

var maxHealth: int = 100
@onready var currentHealth: int = maxHealth

signal health_changed

func _ready() -> void:
	fighter_animation = $FighterAnimation
	nav_agent = $NavigationAgent2D
	attack_point = $AttackPoint
	attack_point_collision_shape = $AttackPoint/CollisionShape2D
	player_detector = $PlayerDetector
	player_detector_collision_shape = $PlayerDetector/CollisionShape2D
	player = $"../Player"
	health_changed.emit()

func _process(_delta: float) -> void:
	# movement
	var direction = to_local(nav_agent.get_next_path_position()).normalized()
	handle_movement(direction)
	# attack point
	update_attack_point_position(direction)
	# player detector
	update_player_detector(direction)
	# animations
	if !is_attacking:
		handle_walk_animation(direction)
	if detecting_player:
		attack(direction)

# movement
func handle_movement(direction: Vector2) -> void:
	velocity = direction * speed
	move_and_slide()

func _on_timer_timeout() -> void:
	makepath()

func makepath() -> void:
	nav_agent.target_position = player.global_position

# animations
func handle_walk_animation(direction: Vector2) -> void:
	if direction != Vector2.ZERO:
		if abs(direction.x) > abs(direction.y):
			if direction.x > 0:
				fighter_animation.play("walk_right")
				last_direction_name = "right"
			else:
				fighter_animation.play("walk_left")
				last_direction_name = "left"
		else:
			if direction.y > 0:
				fighter_animation.play("walk_down")
				last_direction_name = "down"
			else:
				fighter_animation.play("walk_up")
				last_direction_name = "up"
	else:
		# Character is idle, choose the idle animation based on the last direction.
		if last_direction_name != "":
			fighter_animation.play("idle_" + last_direction_name)
			
func handle_attack_animation(direction: Vector2) -> void:
	if direction != Vector2.ZERO:
		if abs(direction.x) > abs(direction.y):
			if direction.x > 0:
				fighter_animation.play("attack_right")
			else:
				fighter_animation.play("attack_left")
		else:
			if direction.y > 0:
				fighter_animation.play("attack_down")
			else:
				fighter_animation.play("attack_up")
	else:
		if last_direction_name != "":
			fighter_animation.play("attack_" + last_direction_name)

func wait_for_attack_animation() -> void:
	await fighter_animation.animation_finished

# combat
func update_attack_point_position(direction: Vector2) -> void:
	if direction != Vector2.ZERO:
		if abs(direction.x) > abs(direction.y):
			last_direction = Vector2(direction.x, 0).normalized()
		else:
			last_direction = Vector2(0, direction.y).normalized()
	attack_point_collision_shape.global_position = attack_point.global_position + last_direction * attack_point_offset

func update_player_detector(direction: Vector2) -> void:
	if direction != Vector2.ZERO:
		if abs(direction.x) > abs(direction.y):
			last_direction = Vector2(direction.x, 0).normalized()
		else:
			last_direction = Vector2(0, direction.y).normalized()
	update_player_detector_position(last_direction)
	update_player_detector_rotation(last_direction)

func update_player_detector_position(last_direction: Vector2) -> void:
	player_detector_collision_shape.global_position = player_detector.global_position + last_direction * attack_point_offset # same offset can be used

func update_player_detector_rotation(direction: Vector2) -> void:
	var angle = atan2(last_direction.y, last_direction.x)
	player_detector.rotation_degrees = rad_to_deg(angle) + 90.0

func attack(direction: Vector2) -> void:
	is_attacking = true
	attack_point_collision_shape.disabled = false
	handle_attack_animation(direction)
	await wait_for_attack_animation()
	attack_point_collision_shape.disabled = true
	is_attacking = false

func take_damage() -> void:
	currentHealth = currentHealth - 10
	health_changed.emit()
	if currentHealth <= 0:
		die()
	
func die() -> void:
	queue_free()

# signals
func _on_player_detector_body_entered(body):
	if body.name == "Player":
		var direction = to_local(nav_agent.get_next_path_position()).normalized()
		detecting_player = true

func _on_player_detector_body_exited(body):
	if body.name == "Player":
		detecting_player = false

func _on_attack_point_body_entered(body):
	if body.name == "Player":
		body.take_damage()

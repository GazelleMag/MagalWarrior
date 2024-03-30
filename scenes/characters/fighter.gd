extends CharacterBody2D

@onready var player: Node2D = $"../Player"
# spawn point
var spawn_point_position: Vector2
var spawn_point_max_distance: float = 400
var spawn_point_distance_threshold: float = 5
# movement
const speed: int = 175
var character_direction: Vector2
var last_direction: Vector2 = Vector2.DOWN
var last_direction_name: String = "down"
@onready var nav_agent: NavigationAgent2D = $NavigationAgent2D
@onready var fighter_animation: AnimatedSprite2D = $FighterAnimation
var chasing_player: bool = false
var back_to_spawn_point: bool = false
# combat
var is_attacking: bool = false
# attack point
@onready var attack_point: Area2D = $AttackPoint
@onready var attack_point_collision_shape: CollisionShape2D = $AttackPoint/CollisionShape2D
var attack_point_offset: float = 30.0
# player range detector
var player_in_range: bool = false
@onready var player_range_detector: Area2D = $PlayerRangeDetector
@onready var player_range_detector_collision_shape: CollisionShape2D = $PlayerRangeDetector/CollisionShape2D
# status
var maxHealth: int = 100
@onready var currentHealth: int = maxHealth

signal health_changed

func _ready() -> void:
	health_changed.emit()

func _process(_delta: float) -> void:
	# spawn point
	check_spawn_point_distance()
	# direction
	if chasing_player and !back_to_spawn_point:
		character_direction = to_local(nav_agent.get_next_path_position()).normalized()
	elif !chasing_player and back_to_spawn_point:
		character_direction = (spawn_point_position - global_position).normalized()
	elif !chasing_player and !back_to_spawn_point:
		character_direction = Vector2.ZERO
	# movement
	handle_movement(character_direction)
	# attack_point
	update_attack_point_position(character_direction)
	# player in range detector
	update_player_range_detector(character_direction)
	# animations
	if !is_attacking:
		handle_walk_animation(character_direction)
	if player_in_range:
		attack(character_direction)
	
# spawn point
func set_spawn_point(spawn_point: Node2D) -> void:
	spawn_point_position = spawn_point.global_position

func check_spawn_point_distance() -> void:
	var distance_to_spawn_point = global_position.distance_to(spawn_point_position)
	if distance_to_spawn_point > spawn_point_max_distance:
		chasing_player = false
		back_to_spawn_point = true
	if distance_to_spawn_point <= spawn_point_distance_threshold:
		back_to_spawn_point = false

# movement
func handle_movement(direction: Vector2) -> void:
	velocity = direction * speed
	move_and_slide()

func _on_timer_timeout() -> void:
	makepath()

func makepath() -> void:
	nav_agent.target_position = player.global_position

func start_chasing_player() -> void:
	if !back_to_spawn_point:
		chasing_player = true

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
			fighter_animation.play("idle_down")
			
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

# attack point
func update_attack_point_position(direction: Vector2) -> void:
	if direction != Vector2.ZERO:
		if abs(direction.x) > abs(direction.y):
			last_direction = Vector2(direction.x, 0).normalized()
		else:
			last_direction = Vector2(0, direction.y).normalized()
	attack_point_collision_shape.global_position = attack_point.global_position + last_direction * attack_point_offset

# player range detector
func update_player_range_detector(direction: Vector2) -> void:
	if direction != Vector2.ZERO:
		if abs(direction.x) > abs(direction.y):
			last_direction = Vector2(direction.x, 0).normalized()
		else:
			last_direction = Vector2(0, direction.y).normalized()
	update_player_range_detector_position()
	update_player_range_detector_rotation()

func update_player_range_detector_position() -> void:
	player_range_detector_collision_shape.global_position = player_range_detector.global_position + last_direction * attack_point_offset # same offset can be used

func update_player_range_detector_rotation() -> void:
	var angle = atan2(last_direction.y, last_direction.x)
	player_range_detector.rotation_degrees = rad_to_deg(angle) + 90.0

# combat
func attack(direction: Vector2) -> void:
	is_attacking = true
	attack_point_collision_shape.disabled = false
	handle_attack_animation(direction)
	await wait_for_attack_animation()
	attack_point_collision_shape.disabled = true
	is_attacking = false

func take_damage(damage: int) -> void:
	currentHealth = currentHealth - damage
	health_changed.emit()
	if currentHealth <= 0:
		die()
	
func die() -> void:
	queue_free()

# signals
func _on_attack_point_body_entered(body):
	if body.name == "Player":
		body.take_damage()

func _on_player_range_detector_body_entered(body):
	if body.name == "Player":
		player_in_range = true

func _on_player_range_detector_body_exited(body):
	if body.name == "Player":
		player_in_range = false	

extends CharacterBody2D

const speed: int = 250
var last_direction: String = "down"
var player_animation: AnimatedSprite2D
var attack_animations: Array = ["attack_up", "attack_down", "attack_left", "attack_right"]
var is_attacking: bool = false

func _ready() -> void:
	player_animation = $PlayerAnimation

func _process(_delta) -> void:
	# movement
	var direction = Input.get_vector("left", "right", "up", "down")
	handle_movement(direction)
	# animations
	if !is_attacking:
		handle_walk_animation(direction)
	if Input.is_action_just_pressed("mouse1") and !is_attacking:
		handle_attack_animation(direction)
		is_attacking = true
		await wait_for_attack_animation()

func handle_movement(direction: Vector2) -> void:
	velocity = direction * speed
	move_and_slide()

func handle_walk_animation(direction: Vector2) -> void:
	if direction != Vector2.ZERO:
		if abs(direction.x) > abs(direction.y):
			if direction.x > 0:
				player_animation.play("walk_right")
				last_direction = "right"
			else:
				player_animation.play("walk_left")
				last_direction = "left"
		else:
			if direction.y > 0:
				player_animation.play("walk_down")
				last_direction = "down"
			else:
				player_animation.play("walk_up")
				last_direction = "up"
	else:
		# Character is idle, choose the idle animation based on the last direction.
		if last_direction != "":
			player_animation.play("idle_" + last_direction)

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
		if last_direction != "":
			player_animation.play("attack_" + last_direction)

func _on_player_animation_animation_finished():
	is_attacking = false

func wait_for_attack_animation():
	await player_animation.animation_finished

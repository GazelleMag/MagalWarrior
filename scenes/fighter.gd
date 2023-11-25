extends CharacterBody2D

const speed: int = 175
var last_direction: String = "down"
var nav_agent: NavigationAgent2D
var fighter_animation: AnimatedSprite2D
@export var player: Node2D

var maxHealth: int = 100
@onready var currentHealth: int = maxHealth

signal health_changed

func _ready() -> void:
	fighter_animation = $FighterAnimation
	nav_agent = $NavigationAgent2D
	health_changed.emit()

func _process(_delta: float) -> void:
	var direction = to_local(nav_agent.get_next_path_position()).normalized()
	handle_movement(direction)
	handle_animation(direction)

func handle_movement(direction: Vector2) -> void:
	velocity = direction * speed
	move_and_slide()

func _on_timer_timeout() -> void:
	makepath()

func makepath() -> void:
	nav_agent.target_position = player.global_position

func handle_animation(direction: Vector2) -> void:
	if direction != Vector2.ZERO:
		if abs(direction.x) > abs(direction.y):
			if direction.x > 0:
				fighter_animation.play("walk_right")
				last_direction = "right"
			else:
				fighter_animation.play("walk_left")
				last_direction = "left"
		else:
			if direction.y > 0:
				fighter_animation.play("walk_down")
				last_direction = "down"
			else:
				fighter_animation.play("walk_up")
				last_direction = "up"
	else:
		# Character is idle, choose the idle animation based on the last direction.
		if last_direction != "":
			fighter_animation.play("idle_" + last_direction)

func take_damage() -> void:
	currentHealth = currentHealth - 10
	health_changed.emit()
	if currentHealth <= 0:
		die()
	
func die() -> void:
	queue_free()

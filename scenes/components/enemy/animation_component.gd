extends Node2D

@export var velocity_component: Node2D
@export var character_animation: AnimatedSprite2D
@export var death_animation: AnimatedSprite2D

func _ready() -> void:
	character_animation.visible = true
	death_animation.visible = false

func handle_walk_animation(direction: Vector2) -> void:
	if direction != Vector2.ZERO:
		if abs(direction.x) > abs(direction.y):
			if direction.x > 0:
				character_animation.play("walk_right")
				velocity_component.last_character_direction_name = "right"
			else:
				character_animation.play("walk_left")
				velocity_component.last_character_direction_name = "left"
		else:
			if direction.y > 0:
				character_animation.play("walk_down")
				velocity_component.last_character_direction_name = "down"
			else:
				character_animation.play("walk_up")
				velocity_component.last_character_direction_name = "up"
	else:
		# Character is idle, choose the idle animation based on the last direction.
		if velocity_component.last_character_direction_name != "":
			character_animation.play("idle_down")

func handle_attack_animation(direction: Vector2) -> void:
	if direction != Vector2.ZERO:
		if abs(direction.x) > abs(direction.y):
			if direction.x > 0:
				character_animation.play("attack_right")
			else:
				character_animation.play("attack_left")
		else:
			if direction.y > 0:
				character_animation.play("attack_down")
			else:
				character_animation.play("attack_up")
	else:
		if velocity_component.last_character_direction_name != "":
			character_animation.play("attack_" + velocity_component.last_character_direction_name)

func handle_death_animation() -> void:
	character_animation.visible = false
	death_animation.visible = true
	death_animation.play("die")

func wait_for_attack_animation() -> void:
	await character_animation.animation_finished
	
func wait_for_death_animation() -> void:
	await death_animation.animation_finished

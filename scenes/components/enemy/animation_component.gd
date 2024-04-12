extends Node2D

#@export var movement_component: Node2D
@onready var character: CharacterBody2D = get_parent()
@onready var character_animation_scene_path: String = "res://scenes/characters/" + character.character_name + "/" + character.character_name + "_animation.tscn"
var character_animation: AnimatedSprite2D

func _ready():
	# Load and instantiate the character animation scene
	var character_scene = load(character_animation_scene_path)
	character_animation = character_scene.instantiate()
	# Add the instantiated scene as a child of this node
	add_child(character_animation)

func handle_walk_animation(direction: Vector2) -> void:
	if direction != Vector2.ZERO:
		if abs(direction.x) > abs(direction.y):
			if direction.x > 0:
				character_animation.play("walk_right")
				character.last_character_direction_name = "right"
			else:
				character_animation.play("walk_left")
				character.last_character_direction_name = "left"
		else:
			if direction.y > 0:
				character_animation.play("walk_down")
				character.last_character_direction_name = "down"
			else:
				character_animation.play("walk_up")
				character.last_character_direction_name = "up"
	else:
		# Character is idle, choose the idle animation based on the last direction.
		if character.last_character_direction_name != "":
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
		if character.last_character_direction_name != "":
			character_animation.play("attack_" + character.last_character_direction_name)

func wait_for_attack_animation() -> void:
	await character_animation.animation_finished

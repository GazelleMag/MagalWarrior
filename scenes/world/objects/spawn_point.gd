extends Marker2D

@export var character_scene: PackedScene
@export var character_name: String
@export var initial_character_direction: Vector2
@onready var level: Node2D = get_parent()
var character: Node2D
var player_inside: bool = false

func _process(_delta: float) -> void:
	if character != null and player_inside:
		character.chase_player()

func spawn_character() -> void:
	character = character_scene.instantiate()
	character.character_name = character_name
	character.global_position = global_position
	character.spawn_point_position = global_position
	level.add_child(character)
	set_process(true)

func _on_area_2d_body_entered(_body):
	player_inside = true

func _on_area_2d_body_exited(_body):
	player_inside = false

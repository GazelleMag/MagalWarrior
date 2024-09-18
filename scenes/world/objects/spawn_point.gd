extends Marker2D

@export var enemy_scene: PackedScene
@export var character_name: String
@onready var level: Node2D = get_parent()
var character: Node2D
var player_inside: bool = false
var character_is_defeated: bool = false

signal character_defeated

func _process(_delta: float) -> void:
	if character != null and player_inside:
		character.chase_player()
	
func spawn_character() -> void:
	character = enemy_scene.instantiate()
	character.name = generate_character_node_name(character_name)
	character.character_name = character_name
	character.global_position = global_position
	character.spawn_point_position = global_position
	character.defeated.connect(_on_character_defeated)
	level.add_child(character)
	set_process(true)
	
func generate_character_node_name(base_name: String) -> String:
	base_name = base_name.capitalize()
	var unique_name = base_name
	var suffix = 1
	while level.has_node(unique_name):
		unique_name = "%s%d" % [base_name, suffix] # this combines both strings
		suffix += 1
	return unique_name

# signals
func _on_area_2d_body_entered(_body):
	player_inside = true

func _on_area_2d_body_exited(_body):
	player_inside = false
	
func _on_character_defeated() -> void:
	character_is_defeated = true
	emit_signal("character_defeated")

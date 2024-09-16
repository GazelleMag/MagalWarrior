extends StaticBody2D

@export var UI: CanvasLayer
@export var spawn_points: Array[Marker2D]

signal ui_warning

func _ready() -> void:
	for spawn_point in spawn_points:
		spawn_point.character_defeated.connect(_on_character_defeated)

func check_all_characters_defeated() -> void:
	for spawn_point in spawn_points:
		if not spawn_point.character_is_defeated:
			return
		# all enemies are defeated
		queue_free()

# signals
func _on_character_defeated() -> void:
	check_all_characters_defeated()

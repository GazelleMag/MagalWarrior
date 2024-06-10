extends StaticBody2D

@export var spawn_points: Array[Marker2D]

func _ready() -> void:
	for spawn_point in spawn_points:
		spawn_point.connect("character_defeated", _on_character_defeated)
		
func _on_character_defeated() -> void:
	check_all_characters_defeated()
	
func check_all_characters_defeated() -> void:
	for spawn_point in spawn_points:
		if not spawn_point.character_is_defeated:
			return
		# all enemies are defeated
		queue_free()

extends Node2D

func _ready() -> void:
	spawn_enemies()

func spawn_enemies() -> void:
	var spawn_points = get_tree().get_nodes_in_group("spawn_points")
	for spawn_point in spawn_points:
		spawn_point.spawn_character()

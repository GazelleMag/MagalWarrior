extends Node2D

var fighter_scene = preload("res://scenes/characters/fighter.tscn")

func _ready() -> void:
	spawn_enemies()

func spawn_enemies() -> void:
	var spawn_points = get_tree().get_nodes_in_group("spawn_points")
	var fighter_count = 1
	for spawn_point in spawn_points:
		var fighter = fighter_scene.instantiate()
		fighter.name = "Fighter" + str(fighter_count)
		fighter.global_position = spawn_point.global_position
		fighter.set_spawn_point(spawn_point)
		add_child(fighter)
		fighter_count += 1
		spawn_point.set_character(fighter)

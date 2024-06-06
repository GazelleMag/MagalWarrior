extends Node2D

@onready var player: CharacterBody2D = $Player
@onready var restart_timer: Timer = $RestartTimer

func _ready() -> void:
	player.player_died.connect(restart_level)
	spawn_enemies()

func spawn_enemies() -> void:
	var spawn_points = get_tree().get_nodes_in_group("spawn_points")
	for spawn_point in spawn_points:
		spawn_point.spawn_character()

func restart_level() -> void:
	Engine.time_scale = 0.75
	restart_timer.start()

func _on_restart_timer_timeout() -> void:
	Engine.time_scale = 1
	get_tree().reload_current_scene()

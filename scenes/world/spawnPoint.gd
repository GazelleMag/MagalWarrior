extends Area2D

var character: CharacterBody2D
var player_inside: bool = false

func _ready() -> void:
	set_process(true)

func _process(_delta: float) -> void:
	if player_inside:
		character.start_chasing_player()

# sets the correspondent character reference for this spawn point
func set_character(character_ref: CharacterBody2D):
	character = character_ref

func _on_body_entered(_body):
	# when player enters this area, start chasing
	player_inside = true
	character.start_chasing_player()

func _on_body_exited(_body):
	player_inside = false

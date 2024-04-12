extends Marker2D

var character: Node2D
var player_inside: bool = false

func _ready() -> void:
	set_process(true)

func _process(_delta: float) -> void:
	if player_inside:
		character.start_chasing_player()

func set_character(character_ref: Node2D):
	character = character_ref

func _on_area_2d_body_entered(_body):
	player_inside = true
	character.start_chasing_player()

func _on_area_2d_body_exited(_body):
	print("its out!")
	player_inside = false

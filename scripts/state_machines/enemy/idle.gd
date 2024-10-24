extends State
class_name Idle

@export var velocity_component: Node2D

func enter() -> void:
	velocity_component.character_direction = Vector2.ZERO
	velocity_component.last_character_direction = Vector2.DOWN

func physics_update(_delta: float) -> void:
	if velocity_component.chasing:
		transitioned.emit(self, "chase")

func update(_delta: float) -> void:
	pass

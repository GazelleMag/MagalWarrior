extends State
class_name Idle

@export var velocity_component: Node2D

func enter() -> void:
#	print("entering idle state")
	velocity_component.character_direction = Vector2.ZERO

func physics_update(_delta: float) -> void:
	if velocity_component.chasing:
		transitioned.emit(self, "chase")

func update(_delta: float) -> void:
	pass

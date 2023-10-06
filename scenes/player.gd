extends CharacterBody2D

var speed: int = 250
var player_animation: AnimatedSprite2D
var last_direction = "down"


func _ready():
	player_animation = $PlayerAnimation


func _process(_delta):
	# input
	var direction = Input.get_vector("left", "right", "up", "down")
	handle_movement(direction)
	handle_animation(direction)


func handle_movement(direction: Vector2):
	velocity = direction * speed
	move_and_slide()


func handle_animation(direction: Vector2):
	if direction != Vector2.ZERO:
		if abs(direction.x) > abs(direction.y):
			if direction.x > 0:
				player_animation.play("walk_right")
				last_direction = "right"
			else:
				player_animation.play("walk_left")
				last_direction = "left"
		else:
			if direction.y > 0:
				player_animation.play("walk_down")
				last_direction = "down"
			else:
				player_animation.play("walk_up")
				last_direction = "up"
	else:
		# Character is idle, choose the idle animation based on the last direction.
		if last_direction != "":
			player_animation.play("idle_" + last_direction)

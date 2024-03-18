extends RigidBody2D

@onready var fireball_animation: AnimatedSprite2D = $FireballAnimation
@onready var timer: Timer = $Timer

func _ready() -> void:
	play_fireball_animation()
	timer.start()
	
# animations
func play_fireball_animation() -> void:
	fireball_animation.play("fireball")

func play_explosion_animation() -> void:
	fireball_animation.play("explosion")
	
func wait_for_animation() -> void:
	await fireball_animation.animation_finished
	
func handle_fireball_orientation(direction: Vector2) -> void:
	var angle = 0
	if direction.x > 0: # Right direction
		angle = 180
	elif direction.x < 0: # Left direction
		angle = 0
	elif direction.y > 0: # Down direction
		angle = -90
	elif direction.y < 0: # Up direction
		angle = 90
	rotation_degrees = angle
	
func explode_fireball() -> void:
	play_explosion_animation()
	await wait_for_animation()
	queue_free()

# signals
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Fighter" or body.name == "TileMap":
		body.take_damage(20) # fireball damage
		explode_fireball()

func _on_timer_timeout() -> void:
	explode_fireball()

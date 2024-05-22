extends RigidBody2D

@export var projectile_animation: AnimatedSprite2D
@onready var timer: Timer = $Timer

func _ready() -> void:
	play_projectile_animation()
	timer.start()
	
# animations
func play_projectile_animation() -> void:
	projectile_animation.play("fireball")

func play_explosion_animation() -> void:
	projectile_animation.play("explosion")
	
func wait_for_animation() -> void:
	await projectile_animation.animation_finished
	
func handle_projectile_orientation(direction: Vector2) -> void:
	var angle: int = 0
	if direction.x > 0: # Right direction
		angle = 180
	elif direction.x < 0: # Left direction
		angle = 0
	elif direction.y > 0: # Down direction
		angle = -90
	elif direction.y < 0: # Up direction
		angle = 90
	rotation_degrees = angle
	
func explode_projectile() -> void:
	play_explosion_animation()
	await wait_for_animation()
	queue_free()

func set_projectile_area_mask(character_name: String) -> void:
	var projectile_area: Area2D = $ProjectileArea
	if character_name == "Player":
		projectile_area.set_collision_mask_value(3, true)
	else:
		projectile_area.set_collision_mask_value(2, true)

# signals
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "TileMap":
		explode_projectile()
	else:
		body.take_damage(20) # fireball damage
		explode_projectile()
	
func _on_timer_timeout() -> void:
	explode_projectile()

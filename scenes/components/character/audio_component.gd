extends Node2D

# footsteps
@onready var footstep_audio_player: AudioStreamPlayer2D = $FootstepAudioPlayer
@export var footstep_sounds: Array[AudioStream]
var footstep_sound_index: int = 0
var step_timer: float = 0.0
var step_interval: float = 0.225
# weapon
@onready var weapon_audio_player: AudioStreamPlayer2D = $WeaponAudioPlayer
@export var weapon_sounds: Array[AudioStream]
var weapon_sound_index: int = 0
# hit
@onready var hit_audio_player: AudioStreamPlayer2D = $HitAudioPlayer
# death
@onready var death_audio_player: AudioStreamPlayer2D = $DeathAudioPlayer
@export var death_sounds: Array[AudioStream]
var death_sound_index: int = 0

func _ready() -> void:
	# in case the character is the player, disable spatial sound
	if get_parent().name == "Player":
		for child in get_children():
			if child is AudioStreamPlayer2D:
				child.max_distance = 2000 

func play_footstep(delta: float, velocity: Vector2) -> void:
	if velocity.length() > 0: # player is moving
		step_timer -= delta
		if step_timer <= 0.0:
			play_step_sound()
			step_timer = step_interval 
	else:
		step_timer = 0.0

func play_step_sound() -> void:
	if footstep_audio_player.playing:
		footstep_audio_player.stop()
	footstep_sound_index = randi () % footstep_sounds.size()
	footstep_audio_player.stream = footstep_sounds[footstep_sound_index]
	footstep_audio_player.pitch_scale = 1.0 + randf() * 0.5 - 0.1 # random pitch variation
	footstep_audio_player.play()
	
func play_weapon_sound() -> void:
	if weapon_audio_player.playing:
		weapon_audio_player.stop()
	weapon_sound_index = randi () % weapon_sounds.size()
	weapon_audio_player.stream = weapon_sounds[weapon_sound_index]
	weapon_audio_player.pitch_scale = 1.0 + randf() * 0.5 - 0.1
	weapon_audio_player.play()
	
func play_hit_sound() -> void:
	if hit_audio_player.playing:
		hit_audio_player.stop()
	hit_audio_player.pitch_scale = 1.0 + randf() * 1.0 - 0.1
	hit_audio_player.play()
	
func play_death_sound() -> void:
	if death_audio_player.playing:
		death_audio_player.stop()
	death_sound_index = randi() % death_sounds.size()
	death_audio_player.stream = death_sounds[death_sound_index]
	death_audio_player.pitch_scale = 1.0 + randf() * 0.5 - 0.1
	death_audio_player.play()

extends TextureButton

@export var texture_progress_bar: TextureProgressBar
@export var timer: Timer
@export var time: Label
@export var key: Label
@export var icon: TextureRect
var key_name: String = ""
var ability: Ability

signal cooldown

# key setter
var change_key: String = "":
	set(value):
		change_key = value
		key.text = value
		if value != "M1" and value != "M2":
			shortcut = Shortcut.new()
			var input_key = InputEventKey.new()
			input_key.keycode = value.capitalize().to_ascii_buffer()[0]
			shortcut.events = [input_key]

func _ready() -> void:
	set_process(false)

func _process(_delta) -> void:
	time.text = "%3.1f" % timer.time_left
	texture_progress_bar.value = timer.time_left

func set_ability(ability_name: String) -> void:
	ability = Ability.new(ability_name)
	set_ability_icon()
	set_ability_cooldown()

func set_ability_icon() -> void:
	var ability_path = "res://assets/sprites/ability_icons/" + ability.name + ".png"
	var texture
	texture = load(ability_path)
	icon.texture = texture

func set_ability_cooldown() -> void:
	timer.wait_time = ability.cooldown_time
	texture_progress_bar.max_value = timer.wait_time
		
func handle_key_use(key_arg) -> void:
	key_name = key_arg
	if timer.is_stopped():
		_on_pressed()

# signals
func _on_pressed() -> void:
	timer.start()
	disabled = true
	set_process(true)

func _on_timer_timeout() -> void:
	disabled = false
	time.text = ""
	set_process(false)
	emit_signal("cooldown", false, key_name)

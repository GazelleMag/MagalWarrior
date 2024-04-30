extends TextureButton

@onready var progress_bar: TextureProgressBar = $TextureProgressBar
@onready var timer: Timer = $Timer
@onready var time: Label = $Time
@onready var key: Label = $Key
@onready var icon: TextureRect = $Icon
var click_type: String = ""

signal mouse_cooldown

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
	progress_bar.value = timer.time_left

func set_skill_icon() -> void:
	var texture
	if change_key == "M1":
		texture = load("res://assets/sprites/icons/sword.png")
	elif change_key == "M2":
		texture = load("res://assets/sprites/icons/fireball.png")
	icon.texture = texture

func set_skill_cooldown() -> void:
	if change_key == "M1":
		timer.wait_time = 0.5 # cooldown of basic attack
		progress_bar.max_value = timer.wait_time
	elif change_key == "M2":
		timer.wait_time = 3.0 # cooldown of fireball
		progress_bar.max_value = timer.wait_time

# signals
func _on_pressed() -> void:
	timer.start()
	disabled = true
	set_process(true)

func _on_timer_timeout() -> void:
	disabled = false
	time.text = ""
	set_process(false)
	emit_signal("mouse_cooldown", false, click_type)

func handle_mouse_click(click_type_arg: String) -> void:
	click_type = click_type_arg
	if timer.time_left <= 0:
		_on_pressed()

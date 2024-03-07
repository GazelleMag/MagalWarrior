extends TextureButton

@onready var progress_bar = $TextureProgressBar
@onready var timer = $Timer
@onready var time = $Time
@onready var key = $Key
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
	progress_bar.max_value = timer.wait_time
	set_process(false)

func _process(_delta) -> void:	
	time.text = "%3.1f" % timer.time_left
	progress_bar.value = timer.time_left

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

extends HBoxContainer

@onready var UI: CanvasLayer = $"../../.."

var skills: Array
# treating mouse1 and mouse2 as keys but handling them with signals
var action_bar_keys: Dictionary = {
	0: "M1",
	1: "M2"
#	1: "q"
}

func _ready() -> void:
	skills = get_children()
	for i in range(skills.size()):
		if i in action_bar_keys.keys():
			skills[i].change_key = action_bar_keys[i]
	skills[0].mouse_cooldown.connect(on_mouse_cooldown)
	skills[1].mouse_cooldown.connect(on_mouse_cooldown)
	
func handle_mouse_click(click_type: String) -> void:
	skills = get_children()
	if click_type == "mouse1":
		skills[0].handle_mouse_click(click_type)
	elif click_type == "mouse2":
		skills[1].handle_mouse_click(click_type)
	
func on_mouse_cooldown(cooldown_status: bool, click_type: String) -> void:
	UI.handle_mouse_cooldown(cooldown_status, click_type)
	

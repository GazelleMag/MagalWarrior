extends HBoxContainer

@export var UI: CanvasLayer

var abilities: Array
# treating mouse1 and mouse2 as keys but handling them with signals
var action_bar_keys: Dictionary = {
	0: "M1",
	1: "M2"
#	2: "q"
}

var ability_button_scene = preload("res://scenes/ui/ability_button.tscn")
	
func handle_mouse_click(click_type: String) -> void:
	if click_type == "mouse1":
		abilities[0].handle_mouse_click(click_type)
	elif click_type == "mouse2":
		abilities[1].handle_mouse_click(click_type)
	
func on_mouse_cooldown(cooldown_status: bool, click_type: String) -> void:
	UI.handle_mouse_cooldown(cooldown_status, click_type)
	
func set_ability_action_bar(ability: Array[Ability]) -> void:
	for i in range(ability.size()):
		if i in action_bar_keys.keys():
			var ability_button = ability_button_scene.instantiate()
			ability_button.change_key = action_bar_keys[i]
			ability_button.set_ability(ability[i].name)
			if action_bar_keys[i] == "M1" or action_bar_keys[i] == "M2":
				ability_button.mouse_cooldown.connect(on_mouse_cooldown)
			add_child(ability_button)
	abilities = get_children()
			

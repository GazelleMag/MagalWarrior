extends HBoxContainer

@export var UI: CanvasLayer

var abilities: Array
var action_bar_keys: Dictionary = {
	0: "M1",
	1: "M2",
	2: "Q"
}

var ability_button_scene = preload("res://scenes/ui/ability_button.tscn")

func on_cooldown(cooldown_status: bool, key: String) -> void:
	UI.handle_cooldown(cooldown_status, key)
	
func handle_key_use(key: String) -> void:
	if key == "mouse1":
		abilities[0].handle_key_use(key)
	elif key == "mouse2":
		abilities[1].handle_key_use(key)
	elif key == "q":
		abilities[2].handle_key_use(key)
		
func set_ability_action_bar(ability: Array[Ability]) -> void:
	for i in range(ability.size()):
		if i in action_bar_keys.keys():
			var ability_button = ability_button_scene.instantiate()
			ability_button.change_key = action_bar_keys[i]
			ability_button.set_ability(ability[i].name)
			ability_button.cooldown.connect(on_cooldown)
			add_child(ability_button)
	abilities = get_children()

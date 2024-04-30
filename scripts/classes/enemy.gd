class_name Enemy

var name: String
var attack_damage: float
var movement_speed: float

func _init(character_name: String) -> void:
	if enemy_characters.has(character_name):
		name = character_name
		attack_damage = enemy_characters[character_name]["attack_damage"]
		movement_speed = enemy_characters[character_name]["movement_speed"]
	else:
		print("Unknown enemy type: ", character_name)
	
const enemy_characters: Dictionary = {
	"thief": {
		"attack_damage": 5,
		"movement_speed": 175
	},
	"brute": {
		"attack_damage": 10,
		"movement_speed": 150
	}
}

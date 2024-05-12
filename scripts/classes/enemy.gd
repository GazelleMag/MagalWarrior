class_name Enemy

var name: String
var attack_damage: int
var movement_speed: int
var max_health: int

func _init(character_name: String) -> void:
	if enemy_characters.has(character_name):
		name = character_name
		attack_damage = enemy_characters[character_name]["attack_damage"]
		movement_speed = enemy_characters[character_name]["movement_speed"]
		max_health = enemy_characters[character_name]["max_health"]
	else:
		print("Unknown enemy: ", character_name)
	
const enemy_characters: Dictionary = {
	"thief": {
		"attack_damage": 5,
		"movement_speed": 175,
		"max_health": 50
	},
	"brute": {
		"attack_damage": 10,
		"movement_speed": 150,
		"max_health": 75
	}
}

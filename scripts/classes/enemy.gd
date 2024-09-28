class_name Enemy

var name: String
var damage: int
var speed: int
var health: int
var abilities: Array[String]

func _init(character_name: String) -> void:
	if enemy_characters.has(character_name):
		name = character_name
		damage = enemy_characters[character_name]["damage"]
		speed = enemy_characters[character_name]["speed"]
		health = enemy_characters[character_name]["health"]
		for ability in enemy_characters[character_name]["abilities"]:
				abilities.append(ability)
	else:
		print("Unknown enemy: ", character_name)
	
const enemy_characters: Dictionary = {
	"thief": {
		"damage": 5,
		"speed": 175,
		"health": 50,
		"abilities": ["basic_attack"]
	},
	"brute": {
		"damage": 10,
		"speed": 150,
		"health": 75,
		"abilities": ["basic_attack", "fireball"]
	}
}

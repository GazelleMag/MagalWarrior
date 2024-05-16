class_name Enemy

var name: String
var damage: int
var speed: int
var health: int

func _init(character_name: String) -> void:
	if enemy_characters.has(character_name):
		name = character_name
		damage = enemy_characters[character_name]["damage"]
		speed = enemy_characters[character_name]["speed"]
		health = enemy_characters[character_name]["health"]
	else:
		print("Unknown enemy: ", character_name)
	
const enemy_characters: Dictionary = {
	"thief": {
		"damage": 5,
		"speed": 175,
		"health": 50
	},
	"brute": {
		"damage": 10,
		"speed": 150,
		"health": 75
	}
}

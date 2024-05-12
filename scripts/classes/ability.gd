class_name Ability

var name: String
var type: String
var damage: int
var cooldown_time: float
var speed: int

func _init(ability_name: String) -> void:
	if abilities.has(ability_name):
		name = ability_name
		type = abilities[ability_name]["type"]
		damage = abilities[ability_name]["damage"]
		cooldown_time = abilities[ability_name]["cooldown_time"]
		speed = abilities[ability_name].get("speed", -1) # in case speed is N/A, assign -1
	else:
		print("Unknown ability: ", ability_name)

const abilities: Dictionary = {
	"basic_attack": {
		"type": "melee",
		"damage": 5,
		"cooldown_time": 0.5
	},
	"fireball": {
		"type": "ranged",
		"damage": 10,
		"cooldown_time": 3,
		"speed": 300
	}
}

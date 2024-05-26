class_name Item

var name: String
var type: String
var heal_amount: int

func _init(item_name: String) -> void:
	if items.has(item_name):
		name = item_name
		type = items[item_name]["type"]
		heal_amount = items[item_name]["heal_amount"] 
	else:
		print("Unknown item: ", item_name)
		
const items: Dictionary = {
	"health_potion": {
		"type": "potion",
		"heal_amount": 20
	}
}

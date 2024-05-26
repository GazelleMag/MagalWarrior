extends Area2D

@export var item_name: String
var item: Item

func _ready() -> void:
	item = Item.new(item_name)

func _on_body_entered(body: CharacterBody2D):
	if body.name == "Player":
		if(item_name == "health_potion"):
			body.heal(item.heal_amount)
		queue_free()

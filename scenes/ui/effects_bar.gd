extends HBoxContainer

@export var effect_icon_scene: Resource = preload("res://scenes/ui/effect_icon.tscn")

func add_effect(effect_name: String) -> void:
	var effect_icon = effect_icon_scene.instantiate()
	effect_icon.set_effect_icon(effect_name)
	add_child(effect_icon)

func remove_effect(effect_name: String) -> void:
	for effect in get_children():
		if effect.effect_name == effect_name:
			remove_child(effect)
			effect.queue_free()
			break

extends TextureRect

var effect_name: String
@export var icon: TextureRect
var icon_path: String = "res://assets/sprites/ability_icons/"

func set_effect_icon(e_name: String) -> void:
	self.effect_name = e_name
	var icon_texture = load(icon_path + effect_name + ".png")
	icon.texture = icon_texture

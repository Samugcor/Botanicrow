@tool
extends Sprite2D

func _ready():
	_update_pivot()
	
func _update_pivot():
	if texture:
		offset = Vector2(texture.get_width() / -2.0, - texture.get_height())

func _on_texture_changed() -> void:
	if texture:
		offset = Vector2(texture.get_width() / -2.0, - texture.get_height())

extends Resource
class_name InteractableClass

@export_category("General information")
@export var id : String
@export var name : String

@export_category("Sprites")
@export var sprite : Texture2D 
@export var selectedSprite: Texture2D

func get_interaction_hint() -> String:
	return "Use"

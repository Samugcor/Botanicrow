extends InteractableClass
class_name NpcClass


@export var dialogFile: String

@export_category("Portraits")
@export var NORMAL: Texture2D
@export var SAD: Texture2D
@export var ANGRY: Texture2D

func get_interaction_hint() -> String:
	return TextVariables.HINT_TALK

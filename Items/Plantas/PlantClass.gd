extends ItemClass
class_name PlantClass

@export_multiline var observations: String
@export var detailView: Texture2D

func _init() -> void:
	hint = TextVariables.HINT_PICK_UP

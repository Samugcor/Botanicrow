extends InteractableClass
class_name ItemClass  

@export_multiline var description : String

func get_interaction_hint() -> String:
	return TextVariables.HINT_PICK_UP

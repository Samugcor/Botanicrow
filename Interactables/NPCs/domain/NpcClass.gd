extends InteractableClass
class_name NpcClass


@export var dialogFile: String

func get_interaction_hint() -> String:
	return TextVariables.HINT_TALK

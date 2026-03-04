
extends ObjectiveClass
class_name GatherObjectiveClass

@export_category("Gather data")
@export var required_item: ItemClass:
	set(value):
		required_item = value
		_update_description()
@export var required_amount: int = 1

func _update_description():
	if required_item:
		description = required_item.description

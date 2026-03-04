extends Node

@onready var controllerReference = get_parent()
@onready var slotContainer = $TextureRect/MarginContainer/GridContainer

	
func getNColumns_from_slotContainer() -> int:
	return slotContainer.columns

func add_child_to_slotContainer(node : Control):
	slotContainer.add_child(node)

func update_slot_render(slot_data : Array):
	var uiSlots: Array = slotContainer.get_children()
	if uiSlots.is_empty():
		push_error("Inventory has no slots")
		return

	for i in range(min(slot_data.size(), uiSlots.size())):
		if slot_data[i]:
			uiSlots[i].updateTexture(slot_data[i])

extends Resource

class_name InventoryClass

@export var slots: Array[InvSlotClass]

signal Update

func add_item(item:PlantClass):
	if !item:
		push_error("No item to be added to inventory")
		return
		
	var existingsStacks = slots.filter(func(slot): return slot.item == item and slot.cantidad<99)
	var emptyslots = slots.filter(func (slot): return slot.item == null)
	
	if !existingsStacks.is_empty():
		print("added to existing stack")
		existingsStacks[0].cantidad += 1
		
	elif !emptyslots.is_empty(): 
		print("added to newd stack")
		emptyslots[0].item = item
		emptyslots[0].cantidad = 1
		
	else:
		return false
	
	emit_signal("Update")
	return true
	
	

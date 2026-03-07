extends Resource

class_name InventoryClass

@export var name:String
@export var slots: Array[InvSlotClass]

signal Update

func _init(identidicaor : String = "", size : int=0) -> void:
	name = identidicaor
	slots.resize(size)
	for i in range(size):
		slots[i] = InvSlotClass.new()

func add_item(item:PlantClass):
	if !item:
		push_error("No item to be added to inventory")
		return
		
	var existingsStacks = slots.filter(func(slot): return slot.item == item and slot.cantidad<99)
	var emptyslots = slots.filter(func (slot): return slot.item == null)
	
	if !existingsStacks.is_empty():
		existingsStacks[0].cantidad += 1
		
	elif !emptyslots.is_empty(): 
		emptyslots[0].item = item
		emptyslots[0].cantidad = 1
		
	else:
		return false
	
	emit_signal("Update")
	#print_rich(string_data())
	return true
	
func set_slots(slotArray :Array[InvSlotClass] ):
	slots.clear()
	slots.append_array(slotArray)

func string_data():
	var string = "[color=cyan]" + name + " contents: [/color]\n"
	for slot in slots:
		string += slot.string_data() + "\n"
		
	return string

func to_dictionary() -> Dictionary:
	var dic = {
		"name": name,
		"slots":[]
	}
	
	for slot in slots:
		dic.slots.append(slot.to_dictionary()) 
		
	return dic

	

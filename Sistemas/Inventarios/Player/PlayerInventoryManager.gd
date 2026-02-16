extends Control

@onready var inv: InventoryClass = preload("res://Sistemas/Inventarios/Player/player_inventory.tres")
@onready var invSlotScene = preload("res://Sistemas/Inventarios/InvSlot.tscn")
@onready var slotContainer = $TextureRect/MarginContainer/GridContainer
 
signal slot_selected

var selected_slot: InvSlotClass

func _ready() -> void:
	inv.Update.connect(update_slots)
	populateSlots()
	update_slots()

func populateSlots():
	for i in range(inv.slots.size()):
		var invSlot = invSlotScene.instantiate()
		invSlot.setup(i)
		invSlot.slot_clicked.connect(_on_slot_clicked)
		slotContainer.add_child(invSlot)
		
func update_slots():
	var uiSlots: Array = slotContainer.get_children()
	if uiSlots.is_empty():
		push_error("Inventory has no slots")
		return
	for i in range(min(inv.slots.size(), uiSlots.size())):
		if inv.slots[i]:
			uiSlots[i].updateTexture(inv.slots[i])

func _on_slot_clicked(index:int):
	selected_slot = inv.slots[index]
	slot_selected.emit(selected_slot)

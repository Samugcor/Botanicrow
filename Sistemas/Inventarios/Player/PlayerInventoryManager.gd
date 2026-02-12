extends Control

@onready var inv: InventoryClass = preload("res://Sistemas/Inventarios/Player/player_inventory.tres")
@onready var uiSlots: Array = $Panel/GridContainer.get_children()


func _ready() -> void:
	inv.Update.connect(update_slots)
	update_slots()

	
func update_slots():
	for i in range(min(inv.slots.size(), uiSlots.size())):
		if inv.slots[i]:
			uiSlots[i].updateTexture(inv.slots[i])

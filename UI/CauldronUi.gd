extends Control

@onready var slotContainer = $TextureRect/HBoxContainer

func set_slot_container(nodes):
	for child in slotContainer.get_children():
		child.queue_free()
		
	for node in nodes:
		slotContainer.add_child(node)

func update_slot(data : InvSlotClass, index : int):
	slotContainer.get_child(index).updateTexture(data)

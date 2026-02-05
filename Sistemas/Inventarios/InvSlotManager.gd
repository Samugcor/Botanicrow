extends Control

@onready var itemDisplay:TextureRect = $ColorRect/ItemDisplay
@onready var amountDisplay: Label = $ColorRect/Label

func updateTexture(slot: InvSlotClass):
	if !slot.item:
		itemDisplay.texture = null
		amountDisplay.visible = false
	else:
		itemDisplay.texture = slot.item.sprite
		amountDisplay.visible = true
		amountDisplay.text = str(slot.cantidad)

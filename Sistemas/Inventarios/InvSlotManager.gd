extends Control

@onready var itemDisplay:TextureRect = $AspectRatioContainer/ColorRect/MarginContainer/ItemDisplay
@onready var amountDisplay: Label = $AspectRatioContainer/ColorRect/MarginContainer/Label

func updateTexture(slot: InvSlotClass):
	if !slot.item:
		itemDisplay.texture = null
		amountDisplay.visible = false
	else:
		itemDisplay.texture = slot.item.sprite
		amountDisplay.visible = true
		amountDisplay.text = str(slot.cantidad)

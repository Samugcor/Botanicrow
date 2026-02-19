extends Control

@onready var itemDisplay:TextureRect = $AspectRatioContainer/Panel/MarginContainer/ItemDisplay
@onready var amountDisplay: Label = $AspectRatioContainer/Panel/MarginContainer/Label
@onready var panelShader = $AspectRatioContainer/Panel.material

signal slot_clicked

var index:int = -1

func _ready() -> void:
	panelShader.set_shader_parameter("rect_size", size)

func setup(i):
	index=i

func updateTexture(slot: InvSlotClass):
	if !slot.item:
		itemDisplay.texture = null
		amountDisplay.visible = false
	else:
		itemDisplay.texture = slot.item.sprite
		amountDisplay.visible = true
		amountDisplay.text = str(slot.cantidad)

func _on_panel_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept") or event.is_action_pressed("click_left"):
		applySelectShader()
		slot_clicked.emit(index)
		accept_event()
		print("slotCliked")

func applyHoverShader():
	panelShader.set_shader_parameter("hover", true)
	panelShader.set_shader_parameter("clicked", false)
	
func applySelectShader():
	panelShader.set_shader_parameter("hover", false)
	panelShader.set_shader_parameter("clicked", true)

func applyNormalShader():
	panelShader.set_shader_parameter("hover", false)
	panelShader.set_shader_parameter("clicked", false)
	

extends Control

@onready var itemDisplay:TextureRect = $AspectRatioContainer/Panel/MarginContainer/ItemDisplay
@onready var amountDisplay: Label = $AspectRatioContainer/Panel/MarginContainer/Label
@onready var panelShader = $AspectRatioContainer/Panel.material

signal mouse_on_hover 

var isInvOpen: bool = false
var index:int = -1
var current_state: Enums.ui_button_state = Enums.ui_button_state.NORMAL

func _ready() -> void:
	panelShader.set_shader_parameter("rect_size", size)
	panelShader.set_shader_parameter("mode", 0)
	current_state = Enums.ui_button_state.NORMAL

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

func _on_panel_mouse_entered() -> void:
	if isInvOpen == false:
		return
	#Si está seleccionado hover no afecta
	if current_state == Enums.ui_button_state.SELECTED:
		return
	mouse_on_hover.emit(index)
	
func applyShader():
	if current_state == Enums.ui_button_state.SELECTED:
		panelShader.set_shader_parameter("mode", 2)
		return
	if current_state == Enums.ui_button_state.HOVERED:
		panelShader.set_shader_parameter("mode", 1)
		return
	panelShader.set_shader_parameter("mode", 0)

func setState(st : Enums.ui_button_state):
	current_state = st
	applyShader()

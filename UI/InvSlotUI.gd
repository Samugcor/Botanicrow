extends Control

@onready var itemDisplay:TextureRect = $Panel/MarginContainer/ItemDisplay
@onready var amountDisplay: Label = $Panel/MarginContainer/Label
@onready var panelShader = $Panel.material
@onready var panel = $Panel

signal mouse_on_hover(index)
signal mouse_on_click(index)

var border_color_hover = null
var border_color_selected = null

var isInvOpen: bool = false
var index:int = -1
var current_state: Enums.ui_button_state = Enums.ui_button_state.NORMAL

func _ready() -> void:
	#panelShader.set_shader_parameter("rect_size", size)
	panelShader.set_shader_parameter("mode", 0)
	if border_color_selected:
		panelShader.set_shader_parameter("border_color_selected",border_color_selected)
	if border_color_hover:
		panelShader.set_shader_parameter("border_color_hover",border_color_hover)
	current_state = Enums.ui_button_state.NORMAL
	amountDisplay.visible = false
	
	InputManager.intent_click_left.connect(_on_slot_clicked)

func setup(i,hover_color = null, select_color = null):
	index=i
	
	if hover_color:
		border_color_hover = hover_color
	if select_color:
		border_color_selected = select_color
		
		
func updateTexture(slot: InvSlotClass):
	if !slot.item:
		itemDisplay.texture = null
		amountDisplay.visible = false
	else:
		itemDisplay.texture = slot.item.sprite
		if slot.cantidad>1:
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

func _on_slot_clicked():
	if isInvOpen == false:
		return
	
	if panel.get_global_rect().has_point(get_global_mouse_position()):
		mouse_on_click.emit(index)
	
func setState(st : Enums.ui_button_state):
	current_state = st
	applyShader()


func _on_panel_mouse_exited() -> void:
	if current_state != Enums.ui_button_state.SELECTED:
		setState(Enums.ui_button_state.NORMAL)

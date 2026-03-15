extends SubmenuController
class_name InventoryManager

@export var slotScene: PackedScene

@onready var invUi = $InventoryUi
 
signal slot_selected(data_slot)

var data: InventoryClass
var first_move: bool = false

var selectedIndex #selected InvSlot indx
var currentIndex #current hover InvSlot indx 
var newIndex	#new hovered InvSlot indx 

func _ready() -> void:

	super()
	data = GameState.inventory
	#print_rich("[color=red]"+data.string_data()+"[/color]")
	data.Update.connect(_on_data_updated)
	
	populateSlots()
	_on_data_updated()
	
	
func activate():
	if super_menu_reference:
		super()
		
	first_move = false
	
	openSlots()
	
	InputManager.intent_ui_move.connect(_on_intent_move)
	InputManager.intent_interact.connect(_on_intent_interact)
	InputManager.intent_click_left.connect(_on_intent_interact)
	
func deactivate():
	if super_menu_reference:
		super()
	
	closeSlots()
	
	InputManager.intent_ui_move.disconnect(_on_intent_move)
	InputManager.intent_interact.disconnect(_on_intent_interact)
	InputManager.intent_click_left.disconnect(_on_intent_interact)
	
func _on_intent_move(axis:Vector2):
	if !is_active:
		return
		
	if axis == Vector2.ZERO:
		return
		
	if !first_move:
		first_move = true
		currentIndex  = 0
		setInvSlotState(currentIndex,Enums.ui_button_state.HOVERED)
		return
		
	#Regular el axis
	axis = HelperFunctions.vectorToVectorDirection(axis)
	
	if axis == Vector2.LEFT:
		newIndex = wrap(currentIndex-1, 0, data.slots.size())
		if currentIndex != selectedIndex:
			setInvSlotState(currentIndex,Enums.ui_button_state.NORMAL)
		if newIndex != selectedIndex:
			setInvSlotState(newIndex,Enums.ui_button_state.HOVERED)
		currentIndex=newIndex
		return
		
	elif axis == Vector2.RIGHT:
		newIndex = wrap(currentIndex+1, 0, data.slots.size())
		if currentIndex != selectedIndex:
			setInvSlotState(currentIndex,Enums.ui_button_state.NORMAL)
		if newIndex != selectedIndex:
			setInvSlotState(newIndex,Enums.ui_button_state.HOVERED)
		currentIndex=newIndex
		return
		
	else:
		var invColumns = invUi.getNColumns_from_slotContainer()
		var current_fila = currentIndex/invColumns
		var current_columna = wrapi(currentIndex%invColumns, 0, invColumns)
		
		if  axis == Vector2.DOWN:
			newIndex = (current_fila-1) * invColumns + current_columna
			if currentIndex != selectedIndex:
				setInvSlotState(currentIndex,Enums.ui_button_state.NORMAL)
			if newIndex != selectedIndex:
				setInvSlotState(newIndex,Enums.ui_button_state.HOVERED)
			currentIndex=newIndex
			return
			
		elif axis == Vector2.UP:
			newIndex = (current_fila+1) * invColumns + current_columna
			if currentIndex != selectedIndex:
				setInvSlotState(currentIndex,Enums.ui_button_state.NORMAL)
			if newIndex != selectedIndex:
				setInvSlotState(newIndex,Enums.ui_button_state.HOVERED)
			currentIndex=newIndex
			return
			
		else:
			push_error("Error movimiento inventario, no se hacer matematicas")

func _on_intent_interact():
	if !currentIndex and currentIndex != 0:
		return
	if selectedIndex and currentIndex != selectedIndex or selectedIndex==0 and currentIndex != selectedIndex:
		setInvSlotState(selectedIndex,Enums.ui_button_state.NORMAL)
		setInvSlotState(currentIndex,Enums.ui_button_state.SELECTED)
		selectedIndex=currentIndex
		return
		
	selectedIndex = currentIndex
	setInvSlotState(selectedIndex,Enums.ui_button_state.SELECTED)
	
func populateSlots():
	for i in range(data.slots.size()):
		var invSlot = slotScene.instantiate()
		invSlot.setup(i)
		invSlot.mouse_on_hover.connect(_on_mouse_hover)
		invUi.add_child_to_slotContainer(invSlot)
		
func _on_data_updated():
	invUi.update_slot_render(data.slots)
	
func setInvSlotState(index: int,  state:Enums.ui_button_state):
	index = wrap(index, 0 , data.slots.size())
	if state == Enums.ui_button_state.SELECTED:
		slot_selected.emit(data.slots[index].item)
	invUi.slotContainer.get_child(index).setState(state)

func _on_mouse_hover( index:int):
	if currentIndex and currentIndex != selectedIndex or currentIndex == 0 and currentIndex != selectedIndex:
		setInvSlotState(currentIndex, Enums.ui_button_state.NORMAL)
	setInvSlotState(index, Enums.ui_button_state.HOVERED)
	currentIndex = index

func openSlots():
	for slot in invUi.slotContainer.get_children():
		slot.isInvOpen = true

func closeSlots():
	for slot in invUi.slotContainer.get_children():
		slot.isInvOpen = false

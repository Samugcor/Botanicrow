extends Control
class_name PlayerInventoryManager

@onready var inv: InventoryClass = preload("res://Sistemas/Inventarios/Player/player_inventory.tres")
@onready var invSlotScene = preload("res://Sistemas/Inventarios/InvSlot.tscn")
@onready var slotContainer = $TextureRect/MarginContainer/GridContainer
 
signal slot_selected

var first_move: bool = false

var selectedIndex #selected InvSlot indx
var currentIndex #current hover InvSlot indx 
var newIndex	#new hovered InvSlot indx 


func _ready() -> void:

	inv.Update.connect(update_slots)
	
	populateSlots()
	update_slots()
	activate()

func activate():
	first_move = false
	
	openSlots()
	
	GameplayState.push(self)
	InputManager.intent_ui_move.connect(_on_intent_move)
	InputManager.intent_interact.connect(_on_intent_interact)
	InputManager.intent_click_left.connect(_on_intent_interact)
	
func deactivate():
	closeSlots()
	
	GameplayState.pop()
	InputManager.intent_ui_move.disconnect(_on_intent_move)
	InputManager.intent_interact.disconnect(_on_intent_interact)
	InputManager.intent_click_left.disconnect(_on_intent_interact)
	
func _on_intent_move(axis:Vector2):
	if GameplayState.current() != self:
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
		newIndex = wrap(currentIndex-1, 0, inv.slots.size())
		if currentIndex != selectedIndex:
			setInvSlotState(currentIndex,Enums.ui_button_state.NORMAL)
		if newIndex != selectedIndex:
			setInvSlotState(newIndex,Enums.ui_button_state.HOVERED)
		currentIndex=newIndex
		return
		
	elif axis == Vector2.RIGHT:
		newIndex = wrap(currentIndex+1, 0, inv.slots.size())
		if currentIndex != selectedIndex:
			setInvSlotState(currentIndex,Enums.ui_button_state.NORMAL)
		if newIndex != selectedIndex:
			setInvSlotState(newIndex,Enums.ui_button_state.HOVERED)
		currentIndex=newIndex
		return
		
	else:
		var invColumns = slotContainer.columns
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
	for i in range(inv.slots.size()):
		var invSlot = invSlotScene.instantiate()
		invSlot.setup(i)
		invSlot.mouse_on_hover.connect(_on_mouse_hover)
		slotContainer.add_child(invSlot)
		
func update_slots():
	var uiSlots: Array = slotContainer.get_children()
	if uiSlots.is_empty():
		push_error("Inventory has no slots")
		return
	for i in range(min(inv.slots.size(), uiSlots.size())):
		if inv.slots[i]:
			uiSlots[i].updateTexture(inv.slots[i])

func setInvSlotState(index: int,  state:Enums.ui_button_state):
	if state==Enums.ui_button_state.SELECTED:
		slot_selected.emit(inv.slots[index])
	slotContainer.get_child(index).setState(state)
	print(index , " slot changed to ",state)

func _on_mouse_hover( index:int):
	if currentIndex and currentIndex != selectedIndex or currentIndex == 0 and currentIndex != selectedIndex:
		setInvSlotState(currentIndex, Enums.ui_button_state.NORMAL)
	setInvSlotState(index, Enums.ui_button_state.HOVERED)
	currentIndex = index

func openSlots():
	for slot in slotContainer.get_children():
		slot.isInvOpen = true

func closeSlots():
	for slot in slotContainer.get_children():
		slot.isInvOpen = false

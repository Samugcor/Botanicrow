extends Control

@onready var inv: InventoryClass = preload("res://Sistemas/Inventarios/Player/player_inventory.tres")
@onready var invSlotScene = preload("res://Sistemas/Inventarios/InvSlot.tscn")
@onready var slotContainer = $TextureRect/MarginContainer/GridContainer
 
signal slot_selected

var selected_slot: InvSlotClass
var first_move: bool = false

func _ready() -> void:
	first_move = false
	
	GameplayState.push(self)
	inv.Update.connect(update_slots)
	InputManager.intent_ui_move.connect(_on_intent_move)
	
	
	
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

func on_inventory_exit():
	GameplayState.pop()
	InputManager.intent_ui_move.disconnect(_on_intent_move)
	
func _on_intent_move(axis:Vector2):
	if GameplayState.current() != self:
		print("Not current gamplayState")
		return
	if axis == Vector2.ZERO:
		print("axis was 0")
		return
	
	print("se detectó movimiento")
	#Regular el axis
	axis = HelperFunctions.vectorToVectorDirection(axis)
	
	if !first_move:
		activateClickSlot(0)
		first_move = true
		print("Era el primer movimiento")
		return
	
	print("Ya había alguien focusseado así que cambiamos al siguiente")
	if axis == Vector2.LEFT:
		activateClickSlot(inv.slots.find_custom(func(slot): return slot == selected_slot) - 1)
		return
		
	elif axis == Vector2.RIGHT:
		activateClickSlot(inv.slots.find_custom(func(slot): return slot == selected_slot) + 1)
		return
		
	else:
		var invColumns = slotContainer.columns
		var invFilas = inv.slots.size()/invColumns
		var currentIndx = inv.slots.find_custom(func(slot): return slot == selected_slot)
		
		var mi_fila = currentIndx/invColumns
		var mi_columna = wrapi(currentIndx%invColumns, 0, invColumns)
		
		if  axis == Vector2.UP:
			mi_fila = wrapi(mi_fila-1, 0, invFilas)
			var newIndex = mi_fila*invColumns + mi_columna 
			activateClickSlot(newIndex)
			return
			
		elif axis == Vector2.DOWN:
			mi_fila = wrapi(mi_fila+1, 0, invFilas)
			var newIndex = mi_fila*invColumns + mi_columna 
			activateClickSlot(newIndex)
			return
			
		else:
			push_error("Error movimiento inventario, no se hacer matematicas")
			
func activateClickSlot(slot_index):
	print("intentando activar slot :" ,slot_index)
	slotContainer.get_child(slot_index).focusSelf()
	var focused := get_viewport().gui_get_focus_owner()
	if focused is Button and slotContainer.is_ancestor_of(focused):
		focused.emit_signal("pressed")
			
func _on_slot_clicked(index:int):
	selected_slot = inv.slots[index]
	slot_selected.emit(selected_slot)
	print("slot selected ", index)

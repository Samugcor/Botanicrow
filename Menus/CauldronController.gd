extends SubmenuController

@export var inv_slot_scene : PackedScene
@onready var view_reference = $CauldronUi

signal cauldron_full_changed_to(a:bool)
signal cauldron_conten_changed

var cauldronContents : Array[InvSlotClass] = []
var fullcauldron : bool = false:
	set(value):
		fullcauldron=value
		cauldron_full_changed_to.emit(value)

func _ready() -> void:
	super()
	cauldronContents = []
	
	QuestManager.new_tracked_quest.connect(_on_new_tracked_quest)
	
func activate():
	super()
	openSlots()

func deactivate():
	super()
	closeSlots()
		
func set_cauldron_slots(quest_data : QuestClass):
	if !quest_data:
		#push_warning("No quest data to set cauldron slots to")
		return
		
	var slot_scenes=[]
	var inv_slot
	var slot_scene
	
	cauldronContents.clear()
	
	for i in range(quest_data.quest_objectives.size()):
		inv_slot = InvSlotClass.new()
		cauldronContents.append(inv_slot)
			
		slot_scene = inv_slot_scene.instantiate()
		slot_scene.setup(i,Color(0.549, 0.247, 0.255))
		slot_scene.mouse_on_click.connect(_on_cauldron_slot_clicked)
		slot_scene.mouse_on_hover.connect(_on_cauldron_slot_hover)
		slot_scenes.append(slot_scene)
		
	view_reference.set_slot_container(slot_scenes)
	
	
		
func openSlots():
	for slot in view_reference.slotContainer.get_children():
		slot.isInvOpen = true

func closeSlots():
	for slot in view_reference.slotContainer.get_children():
		slot.isInvOpen = false
		
func check_cauldron_has(item) -> bool:
	for slot in cauldronContents:
		if slot.item == item:
			return true
	return false

func add_to_cauldron(plant:PlantClass):
	if !plant:
		return
		
	if  fullcauldron:
		push_warning("Full cauldron")
		return
	
	if check_cauldron_has(plant):
		push_warning("Plant already in cauldron")
		return
		
	for i in range(cauldronContents.size()):
		if !cauldronContents[i].item:
			cauldronContents[i].item = plant
			view_reference.slotContainer.get_child(i).updateTexture(cauldronContents[i])
			break
	
	if !check_cauldron_has(null):
		fullcauldron = true
		
func check_potion(potion_components):
	for component in potion_components:
		if !check_cauldron_has(component):
			return false
	return true
func _on_cauldron_slot_clicked(index):
	if !is_active:
		return
	
	# aka if slot is empty
	if cauldronContents[index].item == null:
		return

	#Vaciar el slot en datos	
	cauldronContents[index].item = null
	# Actualizar el render
	view_reference.update_slot(cauldronContents[index],index)
	
	
	if fullcauldron:
		fullcauldron = false
	
	cauldron_conten_changed.emit()
	
func _on_cauldron_slot_hover( index:int):
	var state = view_reference.slotContainer.get_child(index).current_state
	
	if state == Enums.ui_button_state.SELECTED:
		return
	view_reference.slotContainer.get_child(index).setState(Enums.ui_button_state.HOVERED)
	
func _on_new_tracked_quest(quest_data):
	set_cauldron_slots(quest_data)

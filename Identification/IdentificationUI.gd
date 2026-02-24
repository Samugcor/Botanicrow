extends CanvasLayer

@onready var invSlotScene = preload("res://Sistemas/Inventarios/InvSlot.tscn")

@onready var plantDetailTexture = $PlantDetail
@onready var plantNameLabel:Label = $LineName/PlantName
@onready var observationsLabel:Label = $CrowObservations/Label
@onready var notebookText = $NotebookSprite/MarginContainer/RichTextLabel
@onready var addButton = $TextureButton
@onready var cauldronContainer = $Caldero/HBoxContainer
@onready var brewButton = $Brew

#Areas
@onready var plantSelectionInventory: PlayerInventoryManager = $Inventory
#@onready var noteBook = $NoteBook
var current_active_area
var plantaSelecionada: PlantClass

var notebookPages: Array #Array[QuestRuntime]
var currentPage: int #indx in the array of the current page 

var nCauldronSlots : int = 0
var cauldronContents : Array[InvSlotClass]
var fullcauldron : bool = false :
	set(value):
		fullcauldron=value
		if fullcauldron:
			brewButton.visible = true
		else:
			brewButton.visible = false
var cauldronHover : int #indx cauldron hover 

func _ready() -> void:
	GameplayState.push(self)
	
	# ui 
	observationsLabel.get_parent().visible = false
	plantNameLabel.visible = false
	setNotebookContent()
	#nCauldronSlots = 3
	createCalderoSlots()
	addButton.visible = false
	brewButton.visible = false
	

func _process(_delta):
	
	if plantSelectionInventory.get_global_rect().has_point(plantSelectionInventory.get_global_mouse_position()):
		if current_active_area != plantSelectionInventory:
			setActiveArea(plantSelectionInventory)
	else:
		if current_active_area != null:
			current_active_area.deactivate()
			current_active_area=null
		
func setActiveArea(area):
	if current_active_area == area:
		return
	if current_active_area:
		current_active_area.deactivate()
		
	current_active_area = area
	current_active_area.activate()

func setNotebookContent():
	notebookPages = GameState.getActiveQuestsArrByType(QuestClass.questType.IDENTIFICATION)
	
	if notebookPages.is_empty():
		notebookText.text = TextVariables.NOTEBOOK_NO_QUESTS
		return
		
	var active = QuestManager.active_quest
	currentPage = notebookPages.find_custom(func(quest): return quest.quest_id == active)
	
	var questData = QuestManager.get_quest_data(notebookPages[currentPage].quest_id)
	notebookText.clear()
	#notebookText.append_text("[list]\n")
	nCauldronSlots = questData.quest_objectives.size()
	for objective in questData.quest_objectives: 
		notebookText.append_text("* " + objective.description + "\n")
		
	#notebookText.append_text("[/list]")

func createCalderoSlots():
	for i in range(0,nCauldronSlots):
		cauldronContents.append(InvSlotClass.new()) #Añadir invslot
		
		var invSlotTSC = invSlotScene.instantiate() #Añadir escena
		invSlotTSC.setup(i)
		invSlotTSC.isInvOpen = true
		invSlotTSC.mouse_on_click.connect(_on_cauldron_slot_clicked)
		cauldronContainer.add_child(invSlotTSC)
		
func _on_exit_pressed() -> void:
	GameplayState.pop()
	self.queue_free()

func _on_inventory_slot_selected(slot) -> void:
	if slot.item:
		plantaSelecionada = slot.item
		
		plantDetailTexture.texture = plantaSelecionada.detailView
		
		#Preguntar al GameState si se conoce la planta
		plantNameLabel.visible = true
		plantNameLabel.text = plantaSelecionada.name
		
		observationsLabel.get_parent().visible = true
		observationsLabel.text = plantaSelecionada.observations
		if  !fullcauldron and !check_cauldron_has(plantaSelecionada):
			addButton.visible = true
		if check_cauldron_has(plantaSelecionada):
			addButton.visible = false
	else:
		plantDetailTexture.texture = null
		plantNameLabel.visible = false
		observationsLabel.get_parent().visible = false
		addButton.visible = false

func _on_add_button_pressed() -> void:
	if !plantaSelecionada:
		return
		
	if  fullcauldron:
		push_warning("Full cauldron")
		return
	
	if check_cauldron_has(plantaSelecionada):
		push_warning("Plant already in cauldron")
		return
		
	for i in range(cauldronContents.size()):
		if !cauldronContents[i].item:
			cauldronContents[i].item = plantaSelecionada
			cauldronContainer.get_child(i).updateTexture(cauldronContents[i])
			break
	
	if !check_cauldron_has(null):
		fullcauldron = true
		
	addButton.visible = false
	
func check_cauldron_has(type) -> bool:
	for slot in cauldronContents:
		if slot.item == type:
			return true
	return false
		
func _on_cauldron_slot_clicked(index):
	if GameplayState.current() != self:
		return
	
	if cauldronContents[index].item == null:
		return
	
	print("it has:")
	for content in cauldronContents:
		print(content.item)
		
	cauldronContents[index].item = null
	addButton.visible = true
	cauldronContainer.get_child(index).updateTexture(cauldronContents[index])
	if fullcauldron:
		fullcauldron = false
	
	print("it has:")
	for content in cauldronContents:
		print(content.item)
func _on_brew_pressed() -> void:
	check_identification()
	pass # Replace with function body.
	
func check_identification():
	var questData:QuestClass = QuestManager.get_quest_data(notebookPages[currentPage].quest_id)
	
	for objective in questData.quest_objectives:
		if !check_cauldron_has(objective.required_item):
			print("Some objectiive is missing or incorrect")
			return
	
	print("All objectives completed")

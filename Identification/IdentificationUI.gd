extends CanvasLayer

@onready var plantDetailTexture = $PlantDetail
@onready var plantSelectionInventory: PlayerInventoryManager = $Inventory
@onready var plantNameLabel:Label = $LineName/PlantName

@onready var observationsLabel:Label = $CrowObservations/Label

@onready var notebookText = $NoteBook/MarginContainer/RichTextLabel

var current_active_area

var plantaSelecionada: PlantClass

var notebookPages: Array #Es un array de misiones -> Page per mision 
var currentPage: int #indx in the array of the current page 

func _ready() -> void:
	GameplayState.push(self)
	#InputManager.intent_ui_move(_on_intent_ui_move)
	
	# ui 
	observationsLabel.get_parent().visible = false
	plantNameLabel.visible = false
	setNotebookContent()
	
	print(plantSelectionInventory.get_global_rect())

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
	
func _on_exit_pressed() -> void:
	GameplayState.pop()
	self.queue_free()

func setNotebookContent():
	notebookPages = GameState.getActiveQuestsArrByType(QuestClass.questType.IDENTIFICATION)
	print("notebookpages: " , notebookPages)
	
	if notebookPages.is_empty():
		notebookText.text = TextVariables.NOTEBOOK_NO_QUESTS
		return
		
	var active = QuestManager.active_quest
	currentPage = notebookPages.find_custom(func(quest): return quest.quest_id == active)
	print("currentPage: " , currentPage)



func _on_inventory_slot_selected(slot) -> void:
	if GameplayState.current() != self:
		return
		
	if slot.item:
		plantaSelecionada = slot.item
		
		plantDetailTexture.texture = plantaSelecionada.detailView
		
		#Preguntar al GameState si se conoce la planta
		plantNameLabel.visible = true
		plantNameLabel.text = plantaSelecionada.name
		
		observationsLabel.get_parent().visible = true
		observationsLabel.text = plantaSelecionada.observations
		
	else:
		plantDetailTexture.texture = null
		plantNameLabel.visible = false
		observationsLabel.get_parent().visible = false

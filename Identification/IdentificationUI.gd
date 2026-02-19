extends CanvasLayer

@onready var plantDetailTexture = $PlantDetail
@onready var plantSelectionInventory = $Inventory
@onready var plantNameLabel:Label = $LineName/PlantName

@onready var observationsLabel:Label = $CrowObservations/Label

@onready var notebookText = $NoteBook/MarginContainer/RichTextLabel

var plantaSelecionada: PlantClass

var notebookPages: Array #Es un array de misiones -> Page per mision 
var currentPage: int #indx in the array of the current page 

func _ready() -> void:
	GameplayState.push(self)
	InputManager.intent_ui_move(_on_intent_ui_move)
	plantSelectionInventory.slot_selected.connect(_on_slot_selected)
	
	# ui 
	observationsLabel.get_parent().visible = false
	plantNameLabel.visible = false
	setNotebookContent()

func _on_intent_ui_move:
	plantSelectionInventory.
func _on_exit_pressed() -> void:
	GameplayState.pop()
	plantSelectionInventory.slot_selected.disconnect(_on_slot_selected)
	self.queue_free()

func _on_slot_selected(slot):
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

func setNotebookContent():
	notebookPages = GameState.getActiveQuestsArrByType(QuestClass.questType.IDENTIFICATION)
	print("notebookpages: " , notebookPages)
	
	if notebookPages.is_empty():
		notebookText.text = TextVariables.NOTEBOOK_NO_QUESTS
		return
		
	var active = QuestManager.active_quest
	currentPage = notebookPages.find_custom(func(quest): return quest.quest_id == active)
	print("currentPage: " , currentPage)

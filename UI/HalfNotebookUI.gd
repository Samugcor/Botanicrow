extends Control

#GENERAL
@onready var previousPage : TextureButton = $previousPage
@onready var nextPage : TextureButton = $nextPage

@export var ui_sections : Array[Control] = []

#QUEST
@onready var questSection = $NotebookSprite/MarginContainer/QuestSection
@onready var questName  = $NotebookSprite/MarginContainer/QuestSection/VBoxContainer/Nombre
@onready var questDescription = $NotebookSprite/MarginContainer/QuestSection/VBoxContainer/QuestDescription
@onready var questObjectives = $NotebookSprite/MarginContainer/QuestSection/VBoxContainer/QuestObjectives
@onready var objectiveTitle = $NotebookSprite/MarginContainer/QuestSection/VBoxContainer/Label2

#PLANTS
@onready var plantSection = $NotebookSprite/MarginContainer/KnownPlantsSection
@onready var knownPlantView = $NotebookSprite/MarginContainer/KnownPlantsSection/KnownPlant
@onready var notKnownPlantView = $NotebookSprite/MarginContainer/KnownPlantsSection/NotKnown
@onready var plantImage = $NotebookSprite/MarginContainer/KnownPlantsSection/KnownPlant/PlantImage
@onready var plantName = $NotebookSprite/MarginContainer/KnownPlantsSection/KnownPlant/PlantName
@onready var plantDescription = $NotebookSprite/MarginContainer/KnownPlantsSection/KnownPlant/MarginContainer/VBoxContainer/TXTPlantDescription
@onready var plantObservations = $NotebookSprite/MarginContainer/KnownPlantsSection/KnownPlant/MarginContainer/VBoxContainer/TXTPlantObservations



var notebook_type = "Half"
var ui_active_section = 0


#FUNCIONES_________________________________________________________________

func _ready() -> void:
	objectiveTitle.text = "Plant descriptions:"
	
	for section in ui_sections:
		section.visible = false
	
#QUEST SECTION____________________________________________________________
func set_quest_details(data):
		
	questName.text = data.quest_name
	questDescription.text = ""
	questDescription.add_text(data.quest_description)
	
	questObjectives.text = ""
	var objList = "[ul]"
	for objective in data.quest_objectives:
		objList += "[p]"+objective.description + "[/p][br]"
	objList +="[/ul]"

	questObjectives.text = objList
	
	questObjectives.visible = true
	
	set_sections_visibility(ui_sections.find(questSection))

func set_no_items_in_quest_section_view():
	questDescription.text = ""
	questDescription.append_text(TextVariables.NOTEBOOK_NO_QUEST_DETAILS_BBCODE)
	questObjectives.text = ""
	questObjectives.text = "[ul] Get a quest [/ul]"
	set_sections_visibility(ui_sections.find(questSection))
	return

#PLANT SECTION_______________________________________________________________
func set_not_known_plants():
	knownPlantView.visible = false
	notKnownPlantView.visible = true
	set_sections_visibility(ui_sections.find(plantSection))
	
	
func set_known_plant_view(plantData: PlantClass):
	knownPlantView.visible = true
	notKnownPlantView.visible = false
	
	plantImage.texture = plantData.detailView
	plantName.text = plantData.name
	plantDescription.text = plantData.description
	plantObservations.text = plantData.observations
	
	set_sections_visibility(ui_sections.find(plantSection))



func set_sections_visibility(new_active_section = 0):
	
	ui_sections[ui_active_section].visible = false
	ui_active_section = new_active_section
	ui_sections[ui_active_section].visible = true
	
func set_previous_page_visibility(b:bool):
	previousPage.visible = b
	
func set_next_page_visibility(b:bool):
	nextPage.visible = b

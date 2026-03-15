extends Control

@export var listElementScene : PackedScene

#GENERAL
@onready var previousPage : TextureButton = $previousPage
@onready var nextPage : TextureButton = $nextPage

@export var ui_sections : Array[Control] = []

#QUEST
@onready var questSection = $QuestSection
@onready var questListContainer = $QuestSection/HBoxContainer/MarginContainer/VBoxContainer/MisionsContainer
@onready var questDetailsContainer = $QuestSection/HBoxContainer/MarginContainer2/VBoxContainer
@onready var questName = $QuestSection/HBoxContainer/MarginContainer2/VBoxContainer/Nombre
@onready var questDescription = $QuestSection/HBoxContainer/MarginContainer2/VBoxContainer/QuestDescription
@onready var questObjectives = $QuestSection/HBoxContainer/MarginContainer2/VBoxContainer/QuestObjectives
@onready var objectiveTitle = $QuestSection/HBoxContainer/MarginContainer2/VBoxContainer/Label2

#PLANTS
@onready var plantSection = $KnownPlantsSection
@onready var knownPlantView = $KnownPlantsSection/KnownPlant
@onready var notKnownPlantView = $KnownPlantsSection/NotKnown
@onready var plantImage = $KnownPlantsSection/KnownPlant/PlantImage
@onready var plantName = $KnownPlantsSection/KnownPlant/PlantName
@onready var plantDescription = $KnownPlantsSection/KnownPlant/MarginContainer/VBoxContainer/TXTPlantDescription
@onready var plantObservations = $KnownPlantsSection/KnownPlant/MarginContainer/VBoxContainer/TXTPlantObservations

#SETTINGS
@onready var settinsSection = $SettingsSection
@onready var optionsMenu = $OptionsMenu

var notebook_type = "Spread"
var ui_active_section = 0

signal new_tracked_quest_intent(index)

#FUNCIONES____________________________________________________________

func _ready() -> void:
	for section in ui_sections:
		section.visible = false

#QUEST SECTION____________________________________________________________

func set_list_of_active_quests_view(content, active_button):
	#Vaciar container 
	for quest in questListContainer.get_children():
		quest.free()
	
	#Llenar container
	var button_group := ButtonGroup.new()
	for quest in content:
		var listElement = listElementScene.instantiate() as Button
		listElement.text = quest.quest_name
		listElement.button_group = button_group
		questListContainer.add_child(listElement)
		
	button_group.pressed.connect(_on_button_group_pressed)
	
	set_pressed_quest_button(active_button)
	
	set_sections_visibility(ui_sections.find(questSection))

func set_pressed_quest_button(index):
	if questListContainer.get_child_count() > 0: 
		if questListContainer.get_child(0) is not Label:
			questListContainer.get_child(index).button_pressed = true	

func set_no_items_in_quest_section_view():
	for quest in questListContainer.get_children():
		quest.free()
	
	var lbl = Label.new()
	lbl.text = TextVariables.NOTEBOOK_NO_QUESTS
	lbl.add_theme_font_size_override("font_size", 20)
	lbl.modulate = Color("000000ff")
	questListContainer.add_child(lbl)
	
	questDetailsContainer.visible = false
	
	set_sections_visibility(ui_sections.find(questSection))
	return

func set_quest_details(data):
	questName.text = data.quest_name
	questDescription.text = ""
	questDescription.append_text(data.quest_description)
	
	set_objectiveTitle(data)
	
	questObjectives.text = ""
	var objList = "[ul]"
	for objective in data.quest_objectives:
		objList += "[p]" + objective.description + "[/p]"
	
	objList +="[/ul]"
	questObjectives.text = objList
	
	questDetailsContainer.visible = true

func set_objectiveTitle(questData):
	if questData.quest_type == Enums.quest_type.IDENTIFICATION:
		objectiveTitle.text = "Plant descriptions:"
	else:
		objectiveTitle.text = "Objectives:"

#KNOWN PLANTS SECTION _____________________________________________________
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


#SETTINGS SECTION__________________________________________________________

func set_settings_view():
	set_sections_visibility(ui_sections.find(settinsSection))
		

func set_sections_visibility(new_active_section = 0):
	
	ui_sections[ui_active_section].visible = false
	ui_active_section = new_active_section
	ui_sections[ui_active_section].visible = true
	
func set_previous_page_visibility(b:bool):
	previousPage.visible = b
	
func set_next_page_visibility(b:bool):
	nextPage.visible = b


			
func set_option_menu_visibility(b:bool):
	optionsMenu.visible = b
	
func _on_button_group_pressed(button):
	new_tracked_quest_intent.emit(button.get_index())
	MusicManager.play_sound_effect(MusicManager.SE_SELECT_BUTTON)


	
	

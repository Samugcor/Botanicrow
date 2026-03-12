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

#SETTINGS
@onready var settinsSection = $SettingsSection
@onready var optionsMenu = $OptionsMenu

var notebook_type = "Spread"
var ui_active_section = 0

signal active_mision_selected(index)

func _ready() -> void:
	for section in ui_sections:
		section.visible = false

func set_active_quests_view(content):
	#Vaciar container 
	for quest in questListContainer.get_children():
		quest.free()
	
	if content.is_empty():
		var lbl = Label.new()
		lbl.text = TextVariables.NOTEBOOK_NO_QUESTS
		lbl.add_theme_font_size_override("font_size", 20)
		lbl.modulate = Color("000000ff")
		questListContainer.add_child(lbl)
		
		questDetailsContainer.visible = false
		
		set_sections_visibility(ui_sections.find(questSection))
		return
		
	#Llenar container
	var button_group := ButtonGroup.new()
	for quest in content:
		var listElement = listElementScene.instantiate() as Button
		listElement.text = quest.quest_name
		listElement.button_group = button_group
		questListContainer.add_child(listElement)
		
	button_group.pressed.connect(_on_button_group_pressed)
	
	if questListContainer.get_child_count() > 0: 
		for i in range(content.size()):
			if content[i].quest_id == GameState.current_tracked_quest:
				questListContainer.get_child(i).button_pressed = true
				break
	
	set_sections_visibility(ui_sections.find(questSection))

func set_settings_view():
	set_sections_visibility(ui_sections.find(settinsSection))
		
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
		
func set_sections_visibility(new_active_section = 0):
	
	ui_sections[ui_active_section].visible = false
	ui_active_section = new_active_section
	ui_sections[ui_active_section].visible = true
	
func set_previous_page_visibility(b:bool):
	previousPage.visible = b
	
func set_next_page_visibility(b:bool):
	nextPage.visible = b

func set_pressed_quest_button(index):
	if questListContainer.get_child_count() > 0: 
		if questListContainer.get_child(0) is not Label:
			questListContainer.get_child(index).button_pressed = true
			
func set_option_menu_visibility(b:bool):
	optionsMenu.visible = b
	
func _on_button_group_pressed(button):
	active_mision_selected.emit(button.get_index())


	
	

extends Control

@export var listElementScene : PackedScene

@onready var questSection = $QuestSection
@onready var questListContainer = $QuestSection/HBoxContainer/MarginContainer/VBoxContainer/MisionsContainer
@onready var questDetailsContainer = $QuestSection/HBoxContainer/MarginContainer2/VBoxContainer
@onready var questName = $QuestSection/HBoxContainer/MarginContainer2/VBoxContainer/Nombre
@onready var questDescription = $QuestSection/HBoxContainer/MarginContainer2/VBoxContainer/QuestDescription
@onready var questObjectives = $QuestSection/HBoxContainer/MarginContainer2/VBoxContainer/QuestObjectives
@onready var objectiveTitle = $QuestSection/HBoxContainer/MarginContainer2/VBoxContainer/Label2
var notebook_type = "Spread"
var active_section

signal active_mision_selected(index)

func _ready() -> void:
	set_sections_visibility()

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
		print_rich("[color=green]questlist has childs [/color]")
		for i in range(content.size()):
			print_rich("[color=green] vuelta: " + str(i)+ " id: "+ str(content[i].quest_id) +" current_traked_id: "+ str(GameState.current_tracked_quest)+ "[/color]")
			if content[i].quest_id == GameState.current_tracked_quest:
				print_rich("[color=green]current id = current tracked [/color]")
				questListContainer.get_child(i).button_pressed = true
				break
	
	set_sections_visibility(questSection)
	
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
		
func set_sections_visibility(new_active_section = null):
	if !active_section and !new_active_section:
		#Set all sections visibility to false
		return
	if active_section:
		active_section.visible = false
	active_section=new_active_section
	active_section.visible = true
	
func _on_button_group_pressed(button):
	active_mision_selected.emit(button.get_index())

extends Control

@onready var quest_name_lbl  = $NotebookSprite/MarginContainer/VBoxContainer/Nombre
@onready var quest_description_lbl = $NotebookSprite/MarginContainer/VBoxContainer/QuestDescription
@onready var quest_objectives_lbl = $NotebookSprite/MarginContainer/VBoxContainer/QuestObjectives
@onready var lbl2 = $NotebookSprite/MarginContainer/VBoxContainer/Label2

var notebook_type = "Half"
var active_section

func _ready() -> void:
	lbl2.text = "Plant descriptions:"

func set_quest_details(data):
	if data == null:
		quest_description_lbl.text = ""
		quest_description_lbl.append_text(TextVariables.NOTEBOOK_NO_QUEST_DETAILS_BBCODE)
		quest_objectives_lbl.text = ""
		quest_objectives_lbl.text = "[ul] Get a quest [/ul]"
		return
		
	quest_name_lbl.text = data.quest_name
	quest_description_lbl.text = ""
	quest_description_lbl.add_text(data.quest_description)
	
	quest_objectives_lbl.text = ""
	var objList = "[ul]"
	for objective in data.quest_objectives:
		objList += "[p]"+objective.description + "[/p][br]"
	objList +="[/ul]"

	quest_objectives_lbl.text = objList
	
	quest_objectives_lbl.visible = true

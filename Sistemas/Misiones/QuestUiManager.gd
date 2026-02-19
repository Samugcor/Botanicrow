extends Control

@onready var questListContainer = $Panel/HBoxContainer/MarginContainer/MisionsContainer
@onready var questDetails = $Panel/HBoxContainer/MarginContainer2/MisionDetails

var questListLblStyle= load("res://Styles/QuestListLbl.tres") as StyleBoxFlat
func _ready() -> void:
	QuestManager.quest_started.connect(_update_quest_list)

func _update_quest_list(_quest_id):
	var questList = GameState.getActiveQuestsDictionary() #Dictionary of questrutime objects
	
	#vaciar opciones
	for quest in questListContainer.get_children():
		quest.queue_free()
	
	#Poner nuevas opciones
	for quest in questList:
		var lbl = Label.new()
		lbl.text = questList[quest].quest_name
		applyLblStyles(lbl)
		questListContainer.add_child(lbl)

func applyLblStyles(lbl:Label):
	lbl.add_theme_color_override("font_color", Color("#000000"))
	lbl.add_theme_stylebox_override("normal",questListLblStyle)

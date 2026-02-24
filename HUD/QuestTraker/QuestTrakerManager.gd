extends Control

@onready var objectivesContainer = $PanelContainer/MarginContainer/VBoxContainer

func _ready() -> void:
	QuestManager.quest_active_changed.connect(_on_quest_active_changed)
	self.visible=false
	
func _on_quest_active_changed(id):
	if !id:
		self.visible=false
		return
	self.visible=true
	var quest_data = QuestManager.get_quest_data(id)
	
	#vaciar objetivos
	for objectives in objectivesContainer.get_children():
		objectives.queue_free()
	
	#Poner nuevos objetivos
	for objective in quest_data.quest_objectives:
		var label = Label.new()
		label.text = objective.description
		label.add_theme_font_size_override("font_size", 24)
		objectivesContainer.add_child(label)

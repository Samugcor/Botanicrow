extends Control

@onready var objectivesContainer = $PanelContainer/MarginContainer/VBoxContainer

func _ready() -> void:
	QuestManager.new_tracked_quest.connect(_on_quest_active_changed)
	self.visible=false
	
func _on_quest_active_changed(quest_data):
	if !quest_data:
		self.visible=false
		return
	
	self.visible=true
		
	#vaciar objetivos
	for objectives in objectivesContainer.get_children():
		objectives.queue_free()
	
	#Poner nuevos objetivos
	for objective in quest_data.quest_objectives:
		var label = Label.new()
		label.text = objective.description
		label.add_theme_font_size_override("font_size", 20)
		objectivesContainer.add_child(label)

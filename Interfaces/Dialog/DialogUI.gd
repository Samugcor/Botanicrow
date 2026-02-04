extends CanvasLayer

@onready var panel = $Panel
@onready var characterName = $Panel/VBoxContainer/Name
@onready var dialogText = $Panel/VBoxContainer/DialogText
@onready var optionsContainer= $Panel/VBoxContainer/OptionsContainer
@onready var characterPortrait= $CharacterPortrait

func _ready() -> void:
	DialogManager.start_dialog.connect(_on_start_dialog)
	DialogManager.node_changed_dialog.connect(_on_node_changed_dialog)
	DialogManager.end_dialog.connect(_on_end_dialog)
	
	hide_dialogUI()

func _on_start_dialog():
	show_dialogUI()

func _on_node_changed_dialog(id,text,choices):
	characterName.text = id
	dialogText.text = text
	#movidas de opciones
	
func _on_end_dialog():
	#Borrar todo
	hide_dialogUI()

func show_dialogUI():
	self.visible = true
	
func hide_dialogUI():
	self.visible = false

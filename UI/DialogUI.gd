extends CanvasLayer

@export var button_scene : PackedScene

@onready var panel = $Panel
@onready var characterName = $Panel/NameBackdrop/MarginContainer/Name
@onready var dialogText = $Panel/MarginContainer/VBoxContainer/DialogText
@onready var optionsContainer= $Panel/MarginContainer/VBoxContainer/OptionsContainer
#@onready var characterPortrait= $CharacterPortrait

var focus_button: int

func _ready() -> void:
	DialogManager.start_dialog.connect(_on_start_dialog)
	DialogManager.node_changed_dialog.connect(_on_node_changed_dialog)
	DialogManager.end_dialog.connect(_on_end_dialog)
	
	
	hide_dialogUI()

func _on_start_dialog():
	#Ponerse como estado
	GameplayState.push(self)
	InputManager.intent_interact.connect(_on_interact_intent)
	InputManager.intent_ui_move.connect(_on_move_intent)
	show_dialogUI()

func _on_node_changed_dialog(characterId,text,choices):
	characterName.text = characterId
	dialogText.text = text
	
	#vaciar opciones
	for option in optionsContainer.get_children():
		option.queue_free()
	
	#Poner nuevas opciones
	for choice in choices:
		var button = button_scene.instantiate()
		button.button_text = choice.text
		button.button_clicked.connect(_on_option_selected.bind(choice.next))
		optionsContainer.add_child(button)
		
	#Focus first
	if optionsContainer.get_child_count() > 0:
		optionsContainer.get_child(focus_button).set_button_state(Enums.ui_button_state.HOVERED)
	
func _on_end_dialog():
	#Desuscribirse del input
	InputManager.intent_interact.disconnect(_on_interact_intent)
	InputManager.intent_ui_move.disconnect(_on_move_intent)
	#Quitar estado
	GameplayState.pop()
	hide_dialogUI()

func _on_option_selected(next):
	DialogManager.advance(next)
	
#INPUT ================================
func _on_interact_intent():
	if GameplayState.current() != self:
		return
		
	#si no hay opciones avanza
	if optionsContainer.get_child_count() < 1:
		DialogManager.advance()
		return
	
	#Si hay opciones elge la que está focus
	optionsContainer.get_child(focus_button).button_clicked.emit()
	
func _on_move_intent(axis:Vector2):
	if GameplayState.current() != self:
		return
	if axis == Vector2.ZERO:
		return 
	if optionsContainer.get_child_count() < 0:
		return
		
	optionsContainer.get_child(focus_button).set_button_state(Enums.ui_button_state.NORMAL)
	var child_count = optionsContainer.get_child_count()
	focus_button = focus_button + HelperFunctions.vectorToPreviousOrNext(axis)
	focus_button = (focus_button + child_count) % child_count
	optionsContainer.get_child(focus_button).set_button_state(Enums.ui_button_state.HOVERED)
	

#HELPERS ===============================
func show_dialogUI():
	self.visible = true
	
func hide_dialogUI():
	self.visible = false

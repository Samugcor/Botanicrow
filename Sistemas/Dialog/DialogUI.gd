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
		var button = Button.new()
		button.text = choice.text
		button.pressed.connect(_on_option_selected.bind(choice.next))
		optionsContainer.add_child(button)
		setButtonStyles(button)
		
	#Focus first
	if optionsContainer.get_child_count() > 0:
		optionsContainer.get_child(0).grab_focus()
	
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
	var focused := get_viewport().gui_get_focus_owner()
	if focused is Button and optionsContainer.is_ancestor_of(focused):
		focused.emit_signal("pressed")
	
func _on_move_intent(axis:Vector2):
	if GameplayState.current() != self:
		return
	if axis == Vector2.ZERO:
		return 
	if optionsContainer.get_child_count() < 0:
		return
		
	var index := get_viewport().gui_get_focus_owner().get_index()
	var child_count = optionsContainer.get_child_count()
	index = index + HelperFunctions.vectorToPreviousOrNext(axis)
	index = (index + child_count) % child_count
	optionsContainer.get_child(index).grab_focus()
	

#HELPERS ===============================
func show_dialogUI():
	self.visible = true
	
func hide_dialogUI():
	self.visible = false

func setButtonStyles(button:Button):
	var normal := StyleBoxFlat.new()
	normal.bg_color = Color("8f8f8fff")
	
	var hover := normal.duplicate()
	hover.bg_color = Color("5d5d5dff")

	var focus := normal.duplicate()
	focus.bg_color = Color("#5d5d5dff")
	focus.border_width_left = 3
	focus.border_width_right = 3
	focus.border_width_top = 3
	focus.border_width_bottom = 3
	focus.border_color = Color("#7c5cff")

	button.add_theme_stylebox_override("normal", normal)
	button.add_theme_stylebox_override("hover", hover)
	button.add_theme_stylebox_override("focus", focus)
	

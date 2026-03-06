extends SupermenuController

@onready var notebook_ref = $Control/NotebookMenu

func _ready() -> void:
	super()
	
	InputManager.intent_player_menu.connect(_on_intent_player_menu)
	InputManager.intent_esc.connect(_on_intent_esc)

	#self.visible = true

func _on_intent_player_menu():
	if !self.visible:
		self.visible = true
		notebook_ref.set_section_and_page(notebook_ref.ntb_sections.ACTIVE_QUESTS)
		GameplayState.push(self)
		return
	if self.visible:
		self.visible = false
		GameplayState.pop()
		return

func _on_intent_esc():
	if !self.visible:
		notebook_ref.set_section_and_page(notebook_ref.ntb_sections.SETTINGS)
		self.visible = true
		GameplayState.push(self)
		return
	if self.visible:
		self.visible = false
		GameplayState.pop()
		return
	

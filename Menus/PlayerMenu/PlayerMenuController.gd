extends SupermenuController


func _ready() -> void:
	super()
	
	InputManager.intent_player_menu.connect(_on_intent_player_menu)
	#self.visible = true

func _on_intent_player_menu():
	if !self.visible:
		self.visible = true
		GameplayState.push(self)
		return
	if self.visible:
		self.visible = false
		GameplayState.pop()
		return

extends CanvasLayer

func _ready() -> void:
	InputManager.intent_player_menu.connect(_on_intent_player_menu)
	self.visible = false
	
func _on_intent_player_menu():
	if !self.visible:
		self.visible = true
		GameplayState.push(self)
		return
	if self.visible:
		self.visible = false
		GameplayState.pop()
		return

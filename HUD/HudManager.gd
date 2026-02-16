extends CanvasLayer

@onready var interactioHint: Control = $Interaction_hint
@onready var interactioHintLabel: Label = $Interaction_hint/HBoxContainer/Text
@onready var warning: Label = $warning

@export var hint_offset = {"x": 0, "y": 0}

func _ready() -> void:
	GameCommander.connect("interaction_prompt",_on_prompt)
	GameCommander.warning_prompt.connect(_on_warning)
	interactioHint.visible = false
	warning.visible = false

func _on_prompt(interactable):
	if !interactable:
		interactioHint.visible = false
		return
		
	interactioHint.position = interactable.position
	
	if "data" in interactable:
		interactioHintLabel.text = interactable.data.hint
	else: 
		interactioHintLabel.text = TextVariables.HINT_GENERIC
		
	interactioHint.visible = true

func _on_warning(text, isVisible):
	warning.text = text
	warning.visible = isVisible

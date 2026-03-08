extends Control

@onready var interactioHint: Control = $Interaction_hint
@onready var interactioHintLabel: Label = $Interaction_hint/HBoxContainer/Text
@onready var warning: Label = $warning
@onready var questTrakerReference = $QuestTraker

func _ready() -> void:
	
	interactioHint.visible = false
	warning.visible = false

func setInteractionHint(visibility: bool, hint_position : Vector2 = Vector2.ZERO, lerp_amount: float = 0.0):
	if lerp_amount:
		interactioHint.position = interactioHint.position.lerp(hint_position, lerp_amount)
	elif hint_position != Vector2.ZERO:
		interactioHint.position = hint_position
	interactioHint.visible = visibility
	
func setInteractionHintText(text:String):
	interactioHintLabel.text = text

func setWarningHint(visibility : bool):
	warning.visible = visibility
	
func setWarningHintText(text: String):
	warning.text = text

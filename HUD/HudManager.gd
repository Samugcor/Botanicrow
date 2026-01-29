extends Control

@onready var camera: Camera2D = get_parent().get_node("Camera2D")
@onready var interactioHint: Control = $Interaction_hint
@onready var warning: Label = $warning

@export var hint_offset = {"x": 0, "y": 0}

func _ready() -> void:
	interactioHint.visible = false
	warning.visible = false

func _on_prompt(text,isVisible):
	interactioHint.get_node("HBoxContainer/Text").text = text
	interactioHint.visible = isVisible

func _on_warning(text, isVisible):
	warning.text = text
	warning.visible = isVisible

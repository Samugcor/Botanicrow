extends Control

@onready var camera: Camera2D = get_parent().get_node("Camera2D")
@onready var interactioHint: Label = $Interaction_hint
@onready var warning: Label = $warning

@export var hint_offset = {"x": 0, "y": 0}

func _ready() -> void:
	interactioHint.visible = false
	warning.visible = false

func _on_prompt(text,visible, coor):
	interactioHint.text = text
	interactioHint.visible = visible
	if interactioHint.visible:
		interactioHint.position = coor + Vector2(hint_offset.x, hint_offset.y)

func _on_warning(text, visible):
	warning.text = text
	warning.visible = visible

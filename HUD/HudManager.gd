extends CanvasLayer

@onready var interactioHint: Control = $Interaction_hint
@onready var interactioHintLabel: Label = $Interaction_hint/HBoxContainer/Text
@onready var warning: Label = $warning

@export var hint_offset = {"x": 0, "y": 0}

var current_interactable

func _ready() -> void:
	GameCommander.connect("interaction_prompt",_on_prompt)
	GameCommander.warning_prompt.connect(_on_warning)
	interactioHint.visible = false
	warning.visible = false
	
func _process(delta):
	if not current_interactable:
		return

	var target_pos = current_interactable.get_viewport().get_canvas_transform() * current_interactable.position
	interactioHint.position = interactioHint.position.lerp(target_pos, 10.0 * delta)
	
func _on_prompt(interactable):
	#To change to how it was before remove the process parts and the global variable
	#TO DO see which version works best for making the label movement less notizable
	if !interactable:
		interactable = null
		interactioHint.visible = false
		return
	current_interactable = interactable
	#var cam : Camera2D = get_viewport().get_camera_2d()
	#var positionIncamera = HelperFunctions.WorldToViewport(interactable)
	var smoothPosition = interactable.get_viewport().get_canvas_transform() * interactable.position
	#print("positionIncamera ", positionIncamera)
	#print("position in world ", interactable.position)
	#print("position smooth ", smoothPosition)
	interactioHint.position = smoothPosition
		
	if "data" in interactable:
		interactioHintLabel.text = interactable.data.ui_interaction_hint
	else: 
		interactioHintLabel.text = TextVariables.HINT_GENERIC
		
	interactioHint.visible = true

func _on_warning(text, isVisible):
	warning.text = text
	warning.visible = isVisible

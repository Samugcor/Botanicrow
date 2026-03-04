extends Node

@onready var interfaz = $HudUI
@export var hint_offset = {"x": 0, "y": 0}

@onready var player_reference = get_tree().get_current_scene().get_node("World/PlayerCharacter")
var current_interactable

func _ready() -> void:
	player_reference.new_current_interactable.connect(_on_prompt)
	player_reference.unable_to_pick.connect(_on_unable_to_pick)
	
func _process(delta):
	if not current_interactable:
		return

	var target_pos = current_interactable.get_viewport().get_canvas_transform() * current_interactable.position
	interfaz.setInteractionHint(true, target_pos, 10.0 * delta)
	
func _on_prompt(interactable):
	#To change to how it was before remove the process parts and the global variable
	#TO DO see which version works best for making the label movement less notizable
	if !interactable:
		current_interactable=null
		interfaz.setInteractionHint(false)
		return
		
	current_interactable = interactable
	#var cam : Camera2D = get_viewport().get_camera_2d()
	#var positionIncamera = HelperFunctions.WorldToViewport(interactable)
	var smoothPosition = interactable.get_viewport().get_canvas_transform() * interactable.position
	#print("positionIncamera ", positionIncamera)
	#print("position in world ", interactable.position)
	#print("position smooth ", smoothPosition)
		
	if "data" in interactable:
		interfaz.setInteractionHintText(interactable.data.get_interaction_hint()) 
	else: 
		interfaz.setInteractionHintText(TextVariables.HINT_GENERIC) 
		
	interfaz.setInteractionHint(false, smoothPosition)
	interfaz.setInteractionHint(true)

func _on_unable_to_pick():
	interfaz.setWarningHintText(TextVariables.WARNING_INVENTORY_FULL)
	interfaz.setWarningHint(true)
	
	await get_tree().create_timer(2.0).timeout
	interfaz.setWarningHint(false)
	
	
func _on_warning(text, isVisible):
	interfaz.setWarningHint(isVisible)
	interfaz.setWarningHintText(text)

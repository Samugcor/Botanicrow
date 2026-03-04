@tool
extends InteractableController

func _ready() -> void:
	super()
	visual_reference.setSprite(data.sprite)
	
func interact(_player):
	var desk = preload("res://Escenas/IdentificationMenu.tscn").instantiate()
	get_tree().current_scene.add_child(desk)

@tool
extends Node
class_name InteractableController

@export var data : InteractableClass
@export var visual_reference: Node2D
@export var area_reference: Area2D

func _ready() -> void:
	area_reference.body_entered.connect(_on_area_2d_body_entered)
	area_reference.body_exited.connect(_on_area_2d_body_exited)

func _on_area_2d_body_entered(body):
	if body.is_in_group("Player"):
		body.add_interactable(self)

func _on_area_2d_body_exited(body):
	if body.is_in_group("Player"):
		body.remove_interactable(self)
		if visual_reference.has_method("setSprite"):
			visual_reference.setSprite(data.sprite)

func interact(_interactor):
	assert(false, "Child class must implement interact()")

func unmark_as_current_interactable():
	visual_reference.setSprite(data.sprite)

func mark_as_current_interactable():
	if data.selectedSprite:
		visual_reference.setSprite(data.selectedSprite)

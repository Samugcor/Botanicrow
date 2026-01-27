@tool
extends Node2D

var _plant_data: PlantClass
@export var plantData: PlantClass:
	set(value):
		_plant_data = value
		_update_visuals()
	get:
		return _plant_data

@onready var sprite: Sprite2D = $Sprite2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_update_visuals()

func _update_visuals():
	if not sprite or not plantData:
		return
	sprite.texture = plantData.sprite


func _on_area_2d_body_entered(body:Node2D):
	if body.is_in_group("Player"):
		body.add_interactable(self)

func _on_area_2d_body_exited(body: Node2D):
	if body.is_in_group("Player"):
		body.remove_interactable(self)

func interact(player):
	player.pick_up(plantData)
	
func remove_self():
	queue_free()
	

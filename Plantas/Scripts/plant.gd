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

	

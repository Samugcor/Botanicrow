@tool
extends Node2D

var _npc_data: NpcClass
@export var data: NpcClass:
	set(value):
		_npc_data = value
		_update_visuals()
	get:
		return _npc_data

@onready var sprite: Sprite2D = $Sprite2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_update_visuals()

func _update_visuals():
	if not sprite or not data:
		return
	sprite.texture = data.sprite
	
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		body.add_interactable(self)
		

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		body.remove_interactable(self)
		sprite.texture = data.sprite

func interact(_player):
	DialogManager.startNpcDialog(data.id,data.dialogFile)

@tool
extends InteractableController

var npc_data: NpcClass
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super()
	npc_data = data as NpcClass
	visual_reference.setSprite(data.sprite)

func interact(_player):
	DialogManager.startNpcDialog(npc_data)

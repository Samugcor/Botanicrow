@tool
extends InteractableController


var plant_data: PlantClass
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super()
	plant_data = data as PlantClass
	if plant_data == null:
		push_error("PlantController received non-PlantClass data")
		return
		
	visual_reference.setSprite(data.sprite)

func interact(actor):
	if actor.has_method("pick_up"): 
		actor.pick_up(plant_data)
		return
	push_warning("Actor has no method to interact with this objet")
	
func remove_self():
	queue_free()
	

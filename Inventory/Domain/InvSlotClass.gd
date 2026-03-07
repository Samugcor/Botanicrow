extends Resource
class_name InvSlotClass

@export var item: PlantClass 
@export var cantidad: int 

func string_data():
	if item:
		return "[color=green]" + item.name + ":" + str(cantidad) +"[/color]"
	
	return "[color=red] no item [/color]" 

func from_dictionary(dic : Dictionary):
	if !dic.has("item_id") or !dic.has("cantidad"):
		push_error("Invalid dictionary to form InvSlotClass")
		return
	
	item = PlantMAnager.get_plant_data_by_id(dic["item_id"])
	cantidad = dic["cantidad"]

func to_dictionary() -> Dictionary:
	if !item:
		return {}
	return {
		"item_id": item.id,
		"cantidad":cantidad
	}

extends Resource
class_name InvSlotClass

@export var item: PlantClass 
@export var cantidad: int 

func string_data():
	if item:
		return "[color=green]" + item.name + ":" + str(cantidad) +"[/color]"
	
	return "[color=red] no item [/color]" 


func to_dictionary() -> Dictionary:
	if !item:
		return {}
	return {
		"item_id": item.id,
		"cantidad":cantidad
	}

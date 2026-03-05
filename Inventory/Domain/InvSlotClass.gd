extends Resource
class_name InvSlotClass

@export var item: PlantClass 
@export var cantidad: int 

func string_data():
	if item:
		return "[color=green]" + item.name + ":" + str(cantidad) +"[/color]"
	
	return "[color=red] no item [/color]" 

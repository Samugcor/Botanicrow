extends Node
class_name PlantManager

var directory_path = "res://Interactables/Items/planta/data/"
var plant_db = {}

#Funciones de inicio
		
func _ready() -> void:
	_load_all_plants(directory_path)
	
func _load_all_plants(path: String) -> void:
	var dir = DirAccess.open(path)
	if dir == null:
		push_error("Plant folder not found: " + path)
		return

	dir.list_dir_begin()
	var file_name = dir.get_next()

	while file_name != "":
		if file_name.ends_with(".tres"):
			var plant: PlantClass = load(path + file_name)
			_register_plant(plant)
		file_name = dir.get_next()

	dir.list_dir_end()
	
func _register_plant(def: PlantClass) -> void:
	plant_db[def.id] = def	

# Funciones para la obtención de datos
func get_plant_data_by_id(id: String):
	var plantData = plant_db.get(id,null)
	if !plantData:
		push_error("Plant not found inside plant db")
		
	return plantData
	

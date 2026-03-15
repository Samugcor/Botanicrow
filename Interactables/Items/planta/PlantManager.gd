extends Node
class_name PlantManager

signal new_known_plant

var db: PlantDBClass = load("res://Interactables/Items/planta/data/plantDB.tres")
var plant_db = {}

#Funciones de inicio
		
func _ready() -> void:
	_load_all_plants()
	
func _load_all_plants() -> void:
	for plant in db.plants:
		_register_plant(plant)
		
func _register_plant(def: PlantClass) -> void:
	plant_db[def.id] = def	

# Funciones para la obtención de datos
func get_plant_data_by_id(id: String):
	var plantData = plant_db.get(id,null)
	if !plantData:
		push_error("Plant not found inside plant db")
		
	return plantData

func get_data_of_known_plants():
	var knowplants = GameState.known_plants.duplicate()
	var data_known_plants = []
	for plantid in knowplants:
		data_known_plants.append(get_plant_data_by_id(plantid)) 
	return data_known_plants
	
#Funciones para el registro de datos

func set_known_plants_from_quest(quest_data : QuestClass):
	if quest_data.quest_type != Enums.quest_type.IDENTIFICATION:
		return
	for objective in quest_data.quest_objectives:
		if objective is GatherObjectiveClass:
			if objective.required_item is PlantClass:
				GameState.addKnownPlant(objective.required_item.id)
				new_known_plant.emit()

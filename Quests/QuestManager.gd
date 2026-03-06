extends Node

signal quest_started(quest_id:String)

var directory_path = "res://Quests/data/"
var quest_db = {}

#Funciones de inicio
		
func _ready() -> void:
	_load_all_quests(directory_path)
	
func _load_all_quests(path: String) -> void:
	var dir = DirAccess.open(path)
	if dir == null:
		push_error("Quest folder not found: " + path)
		return

	dir.list_dir_begin()
	var file_name = dir.get_next()

	while file_name != "":
		if file_name.ends_with(".tres"):
			var quest: QuestClass = load(path + file_name)
			_register_quest(quest)
		file_name = dir.get_next()

	dir.list_dir_end()
	
func _register_quest(def: QuestClass) -> void:
	quest_db[def.quest_id] = def	

# Funciones para la obtención de datos
func get_quest_data_by_id(id: String):
	var questData = quest_db.get(id,null)
	if !questData:
		push_error("Mision not found inside mision db")
		
	return questData
	
func get_quests_data_by_state(state : Enums.quest_state ):
	var quest_ids_by_state = GameState.getQuestIdsByState(state)
	var result = []
	
	for key in quest_db:
		var quest_data = quest_db[key]
		if quest_ids_by_state.has(quest_data.quest_id):
			result.append(quest_data)
	
	return result
	
func get_quests_data_by_type(type : Enums.quest_type):
	var quest_ids_by_type = GameState.getQuestIdsByType(type)
	var result = []
	
	for key in quest_db:
		var quest_data = quest_db[key]
		if quest_ids_by_type.has(quest_data.quest_id):
			result.append(quest_data)
	
	return result
	
func get_quests_data_by_type_and_state(type : Enums.quest_type, state : Enums.quest_state):
	var quest_ids_by_filter = GameState.getQuestIdsByTypeAndState(type,state)
	var result = []
	
	for key in quest_db:
		var quest_data = quest_db[key]
		if quest_ids_by_filter.has(quest_data.quest_id):
			result.append(quest_data)
	
	return result


#Funciones del sistema
func startQuest(id):
	#Vemos si ya está activa
	if !GameState.checkCondition("no_quest:id"):
		push_warning("Mision already active")
		return
		
	#Si no la buscamos en la questdb
	var questData = get_quest_data_by_id(id)
	
	#si no se encuentra notificar
	if !questData:
		push_error("No mision to start")
		return
	
	var questruntime = createQuestRuntime(questData)
	
	#Con los datos de quest db creamos un questRuntime object y lo guardamos en GameState
	#Se emite una señal para que la ui de listaMisiones se actualice
	GameState.setQuest(id, questruntime)
	#Marcar como misión activa
	GameState.setTrackedQUest(id)
	
	quest_started.emit(id)

func createQuestRuntime(quest: QuestClass):
	var questState = QuestRuntime.new()
	questState.quest_id = quest.quest_id
	questState.quest_type = quest.quest_type
	questState.quest_state = Enums.quest_state.ACTIVE

	return questState

func completeActiveQuest(quest_id: String):
	var err : Error = GameState.setQuestState(quest_id, Enums.quest_state)
	if err != OK:
		push_error("Error compleating quest ", err)

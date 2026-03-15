extends Node

signal quest_started(quest_id:String)
signal quest_completed(quest_id:String)
signal new_tracked_quest(quest_data)

var db: QuestDBClass = load("res://Quests/data/questDB.tres")
var quest_db = {}

#Funciones de inicio
		
func _ready() -> void:
	_load_all_quests()
	
func _load_all_quests() -> void:
	for quest in db.quests:
		_register_quest(quest)
	
func _register_quest(def: QuestClass) -> void:
	quest_db[def.quest_id] = def	

# Funciones para la obtención de datos
func get_quest_data_by_id(id: String):
	if !id:
		return
	print("Get quest data by id")
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
	print_rich("[color=orange]get_quest_data_by_id from start new quest[/color]")
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
	setTrackedQuest(questData)
	
	quest_started.emit(id)

func createQuestRuntime(quest: QuestClass):
	var questState = QuestRuntime.new()
	questState.quest_id = quest.quest_id
	questState.quest_type = quest.quest_type
	questState.quest_state = Enums.quest_state.ACTIVE

	return questState

func completeActiveQuest(quest_id: String):
	var err : Error = GameState.setQuestState(quest_id, Enums.quest_state.COMPLETED)
	if err != OK:
		push_error("Error compleating quest ", err)
		return
		
	quest_completed.emit(quest_id)
	
	var misiones_activas = GameState.getQuestIdsByState( Enums.quest_state.ACTIVE)
	if misiones_activas.is_empty():
		setNoTrackedQuest()
		return
	setTrackedQuest(get_quest_data_by_id(misiones_activas[0]))

func setTrackedQuest(quest_data : QuestClass):
	GameState.current_tracked_quest = quest_data.quest_id
	new_tracked_quest.emit(quest_data)
	
func setNoTrackedQuest():
	GameState.current_tracked_quest = ""
	new_tracked_quest.emit(null)

func get_tracked_quest_data():
	return get_quest_data_by_id(GameState.current_tracked_quest)

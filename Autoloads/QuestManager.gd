extends Node

signal quest_started(quest_id:String)
signal quest_active_changed(quest_id:String)

var directory_path = "res://Sistemas/Misiones/QuestResourcess/"
var quest_db = {}

var active_quest: String
		
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

func startQuest(id):
	#Vemos si ya está activa
	if !GameCommander.askGameState("quest_not_active:%s" % id):
		push_warning("Mision already active")
		return
		
	#Si no la buscamos en la questdb
	var questData = quest_db.get(id,false)
	
	#si no se encuentra notificar
	if !questData:
		push_error("Mision not found inside mision db")
		return
	
	var questruntime = createQuestRuntime(questData)
	
	#Con los datos de quest db creamos un questRuntime object y lo guardamos en GameState
	#Se emite una señal para que la ui de listaMisiones se actualice
	GameCommander.saveQuestState(questruntime)
	quest_started.emit(questruntime.quest_id)
	
	#Marcar como misión activa
	setActiveQuest(questruntime.quest_id)

func createQuestRuntime(quest:QuestClass):
	var questState = QuestRuntime.new()
	questState.quest_id = quest.quest_id
	questState.quest_name = quest.quest_name
	questState.quest_type = quest.quest_type
	questState.quest_state = QuestRuntime.State.ACTIVE

	return questState
		
func get_quest_data(id: String):
	var questData = quest_db.get(id,false)
	if !questData:
		push_error("Mision not found inside mision db")
		
	return questData
	
func setActiveQuest(id: String):
	active_quest= id
	quest_active_changed.emit(id)


	

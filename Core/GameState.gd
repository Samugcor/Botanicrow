extends Node

signal new_traked_quest(current_tracked_quest)

#Level Data
var current_level_path: String = "res://Escenas/CasaBruja.tscn"
var current_spawn_id: String = "start_game"

var current_tracked_quest: String: #id
	set(value):
		current_tracked_quest=value
		new_traked_quest.emit(value)
		
var npcs = {}
var quests = {} # {quest_id : QuestRuntime}

#func loadGameState
func newGame():
	current_level_path="res://Escenas/CasaBruja.tscn"
	current_spawn_id="start_game"
	
	current_tracked_quest = ""
	
	npcs = {}
	quests = {} 
	
func checkCondition(condition:String) -> bool:
	var parts = condition.split(":")
	var type = parts[0]
	var values = parts.slice(1)
	print("condition: ", condition)
	
	for value in values:
		match type:
			"not_met":
				return not npcs.get(value,false)
				
			"quest_not_active":
				return !is_quest_state(value, Enums.quest_state.ACTIVE)
				
			"quest_active_or_completed":
				return true if quests.get(value, false) else false
				
			"no_quest":
				return not quests.get(value,false)
				
	push_warning("Unknown condition: %s" % condition)
	return false

func setNpc(key: String,value: bool):
	npcs[key]=value

func setQuest(key: String,value: QuestRuntime):
	quests[key]=value
	
func setTrackedQUest(id:String):
	current_tracked_quest=id

func getQuestRuntimeDictionary():
	return quests

func getQuestIdsByState(state : Enums.quest_state):
	var valid_ids =[]
	
	for key in quests:
		var quest_runtime = quests[key]
		if quest_runtime.quest_state == state:
			valid_ids.append(quest_runtime.quest_id)

	return valid_ids

func getQuestIdsByType(type : Enums.quest_type):
	var valid_ids =[]
	
	for key in quests:
		var quest_runtime = quests[key]
		if quest_runtime.quest_type == type:
			valid_ids.append(quest_runtime.quest_id)

	return valid_ids

func getQuestIdsByTypeAndState(type : Enums.quest_type, state : Enums.quest_state):
	var valid_ids =[]
	
	for key in quests:
		var quest_runtime = quests[key]
		if quest_runtime.quest_type == type and quest_runtime.quest_state == state:
			valid_ids.append(quest_runtime.quest_id)

	return valid_ids

func is_quest_state(id : String , state : Enums.quest_state):
	if !quests.has(id) and state == Enums.quest_state.INACTIVE:
		return true
	elif !quests.has(id) and state != Enums.quest_state.INACTIVE:
		return false
		
	if quests[id].quest_state == state:
		return true
	else :
		return false

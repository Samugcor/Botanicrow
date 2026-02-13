extends Node


#Level Data
var current_level_path: String = "res://Escenarios/CasaBruja/CasaBruja.tscn"
var current_spawn_id: String = "start_game"

var npcs = {}
var quests = {}

#func loadGameState
func newGame():
	current_level_path="res://Escenarios/CasaBruja/CasaBruja.tscn"
	current_spawn_id="start_game"
	
	npcs = {}
	quests = {}
	
func checkCondition(condition:String) -> bool:
	var parts = condition.split(":")
	var type = parts[0]
	var values = parts.slice(1)
	print(values)
	
	for value in values:
		match type:
			"not_met":
				return not npcs.get(value,false)
				
			"quest_not_active":
				return not quests.get(value,false)
				
	push_warning("Unknown condition: %s" % condition)
	return false

func setNpc(key: String,value: bool):
	npcs[key]=value

func setQuest(key: String,value: QuestRuntime):
	quests[key]=value

func getActiveQuests():
	return quests

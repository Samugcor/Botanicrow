extends Node

var npcs = {}
var quests = {}

#func loadGameState

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

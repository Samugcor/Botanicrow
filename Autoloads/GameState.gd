extends Node

var met_npcs = {}
var completed_quest = {}

func checkCondition(condition:String) -> bool:
	var parts = condition.split(":")
	var type = parts[0]
	var value = parts[1]
	
	match type:
		"not_met":
			return not met_npcs.get(value,false)
			
	push_warning("Unknown condition: %s" % condition)
	return false

func applyEffect():
	print("Recuerda aplicar efectos ")

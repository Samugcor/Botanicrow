extends Node


func applyEffect(effect:String) -> void:
	var parts = effect.split(":")
	var type = parts[0]
	var values = parts.slice(1)
	
	for value in values:
		match type:
			"met":
				GameState.setNpc(values[0],true)
				return
			"activate_quest": 
				QuestManager.startQuest(values[0])
				return
	
	push_warning("Unknown effect: %s" % effect)

extends Node

signal interaction_prompt(interactable)
signal warning_prompt(text)

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
				print("Game comander ordered to start mision")
				QuestManager.startQuest(values[0])
				return
	
	push_warning("Unknown effect: %s" % effect)

func askGameState(condition):
	return GameState.checkCondition(condition)
	
func saveQuestState(questState: QuestRuntime):
	GameState.setQuest(questState.quest_id, questState)


# UI
func showInteractableHint(interactable):
	interaction_prompt.emit(interactable)

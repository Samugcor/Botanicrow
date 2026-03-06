extends Resource
class_name QuestRuntime

@export var quest_id: String
@export var quest_type: Enums.quest_type
@export var quest_state: Enums.quest_state

func to_dictionary() -> Dictionary:
	return {
		"quest_id":quest_id,
		"quest_type":quest_type,
		"quest_state":quest_state
	}

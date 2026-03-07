extends Resource
class_name QuestRuntime

@export var quest_id: String
@export var quest_type: Enums.quest_type
@export var quest_state: Enums.quest_state

func from_dictionary (dic : Dictionary):
	if !dic.has("quest_id") or !dic.has("quest_type") or !dic.has("quest_state"):
		push_error("Invalid data to form QuestRuntime")
		return
	quest_id = dic["quest_id"]
	quest_type = dic["quest_type"]
	quest_state = dic["quest_state"]
	
func to_dictionary() -> Dictionary:
	return {
		"quest_id":quest_id,
		"quest_type":quest_type,
		"quest_state":quest_state
	}

extends Resource
class_name QuestRuntime

enum State {
	INACTIVE = 0,
	ACTIVE = 1,
	COMPLETED = 2
}

@export var quest_id: String
@export var quest_type: QuestClass.questType
@export var quest_name: String
@export var quest_state: int

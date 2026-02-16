extends Resource
class_name QuestClass

enum questType {
	IDENTIFICATION,
	OTHER
}

@export var quest_id: String
@export var quest_name: String
@export var ques_type: questType
@export_multiline var quest_description: String
@export var quest_objectives: Array[ObjectiveClass]=[]
@export var quest_rewards: =[]

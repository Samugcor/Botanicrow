extends Area2D

@export var destination_level_path: String
@export var destination_spawn: String


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		print("player entered")
		var lm = get_tree().get_first_node_in_group("Scene_manager")
		lm.request_enviroment_change(destination_level_path, destination_spawn)

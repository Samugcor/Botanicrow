extends Node2D


func interact(player):
	get_tree().change_scene_to_file("res://Identification/IdentificationMenu.tscn")

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		body.add_interactable(self)


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		body.remove_interactable(self)

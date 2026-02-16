extends Node2D

func interact(_player):
	var desk = preload("res://Identification/IdentificationMenu.tscn").instantiate()
	get_tree().current_scene.add_child(desk)

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		body.add_interactable(self)


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		body.remove_interactable(self)

extends Control

func _on_start_pressed() -> void:
	GameState.newGame()
	get_tree().change_scene_to_file("res://game_demo.tscn")
	

func _on_options_pressed() -> void:
	print("options pressed")


func _on_exit_pressed() -> void:
	get_tree().quit()

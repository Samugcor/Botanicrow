extends Control

@onready var loadButton = $VBoxContainer/LoadGame

func _ready() -> void:
	if !FileHandler.check_if_file_exist(GameState.SAVE_PATH_JSON):
		loadButton.disabled = true
	else : 
		loadButton.disabled = false
	
func _on_start_pressed() -> void:
	await Transition.play_start_transition(Transition.TransitionType.FADE_IN) 
	GameState.newGame()
	get_tree().change_scene_to_file("res://Escenas/game_demo.tscn")
	

func _on_load_game_pressed() -> void:
	await Transition.play_start_transition(Transition.TransitionType.FADE_IN) 
	GameState.load_data_json()
	
	
	get_tree().change_scene_to_file("res://Escenas/game_demo.tscn")
	
func _on_options_pressed() -> void:
	print("options pressed")


func _on_exit_pressed() -> void:
	get_tree().quit()

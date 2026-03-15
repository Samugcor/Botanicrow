extends Control

@onready var loadButton = $VBoxContainer/LoadGame
@onready var optionsMenu = $OptionsMenu

func _ready() -> void:
	optionsMenu.visible = false
	if !FileHandler.check_if_file_exist(GameState.SAVE_PATH_JSON):
		loadButton.disabled = true
	else : 
		loadButton.disabled = false
	
func _on_start_pressed() -> void:
	MusicManager.play_sound_effect(MusicManager.SE_SELECT_BUTTON)
	await Transition.play_start_transition(Transition.TransitionType.FADE_IN) 
	GameState.newGame()
	get_tree().change_scene_to_file("res://Escenas/game_demo.tscn")
	

func _on_load_game_pressed() -> void:
	MusicManager.play_sound_effect(MusicManager.SE_SELECT_BUTTON)
	await Transition.play_start_transition(Transition.TransitionType.FADE_IN) 
	GameState.load_data_json()
	
	
	get_tree().change_scene_to_file("res://Escenas/game_demo.tscn")
	
func _on_options_pressed() -> void:
	MusicManager.play_sound_effect(MusicManager.SE_SELECT_BUTTON)
	optionsMenu.visible = true


func _on_exit_pressed() -> void:
	MusicManager.play_sound_effect(MusicManager.SE_SELECT_BUTTON)
	get_tree().quit()



func _on_button_entered() -> void:
	MusicManager.play_sound_effect(MusicManager.SE_NEXT_BUTTON)

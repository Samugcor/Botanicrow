extends Node

const SE_TURN_PAGE = "turn_page"
const SE_NEXT_BUTTON = "next_button"
const SE_SELECT_BUTTON = "select_button"
const SE_UI_SALIR = "ui_salir"
const SE_SUCCESS = "success"

var BG_music_node : AudioStreamPlayer = null
var BG_music_track = load("res://Assets/Music/airtone_-_timebeing_1.mp3")

var SE_node: AudioStreamPlayer = null
var SE_is_playing: bool =false
var sound_effects_tracks :={
	SE_TURN_PAGE:load("res://Assets/Music/Soundeffects/ui/Pasarpagina.wav"),
	SE_NEXT_BUTTON:load("res://Assets/Music/Soundeffects/ui/se_sys_click_short.wav"),
	SE_SELECT_BUTTON:load("res://Assets/Music/Soundeffects/ui/se_sys_click.wav"),
	SE_UI_SALIR: load("res://Assets/Music/Soundeffects/ui/se_sys_cancel.wav"),
	SE_SUCCESS: load("res://Assets/Music/Soundeffects/ui/UI_Wrapping_Open_Appear.wav")
}

func _ready() -> void:
	BG_music_node = AudioStreamPlayer.new()
	BG_music_node.stream = BG_music_track
	BG_music_node.autoplay = true
	BG_music_node.bus = "Music"
	add_child(BG_music_node)
	
	SE_node = AudioStreamPlayer.new()
	SE_node.autoplay = false
	SE_node.bus = "SoundEffects"
	add_child(SE_node)
	
	
func play_sound_effect(track_name:String):
	if SE_node.playing:
		return
	SE_node.stream = sound_effects_tracks[track_name]
	SE_node.play()

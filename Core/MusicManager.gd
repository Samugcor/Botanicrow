extends Node

var BG_music_node : AudioStreamPlayer = null
var BG_music_track = load("res://Assets/Music/airtone_-_timebeing_1.mp3")


func _ready() -> void:
	print("play music")
	BG_music_node = AudioStreamPlayer.new()
	BG_music_node.stream = BG_music_track
	BG_music_node.autoplay = true
	BG_music_node.bus = "Music"
	add_child(BG_music_node)
	

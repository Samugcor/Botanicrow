extends Control

@onready var genral_volume_slider = $Panel/MarginContainer/AudioOptions/VBoxContainer2/MarginContainer/VBoxContainer/GeneralVolume
@onready var music_volume_slider = $Panel/MarginContainer/AudioOptions/VBoxContainer2/MarginContainer/VBoxContainer/MusicVolume
@onready var ambience_volume_slider = $Panel/MarginContainer/AudioOptions/VBoxContainer2/MarginContainer/VBoxContainer/AmbienceVolume

func _ready() -> void:
	self.visible = false
	
	genral_volume_slider.value = db_to_linear(AudioServer.get_bus_volume_db(0))
	music_volume_slider.value = db_to_linear(AudioServer.get_bus_volume_db(1))
	ambience_volume_slider.value = db_to_linear(AudioServer.get_bus_volume_db(2))

func _on_button_pressed() -> void:
	self.visible = false


func _on_ambience_volume_drag_ended(value_changed: bool) -> void:
	if value_changed:
		AudioServer.set_bus_volume_db(2, linear_to_db(ambience_volume_slider.value))


func _on_music_volume_drag_ended(value_changed: bool) -> void:
	if value_changed:
		AudioServer.set_bus_volume_db(1, linear_to_db(music_volume_slider.value))


func _on_general_volume_drag_ended(value_changed: bool) -> void:
	if value_changed:
		AudioServer.set_bus_volume_db(0, linear_to_db(genral_volume_slider.value))

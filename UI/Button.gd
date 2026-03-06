@tool
extends Control

@onready var texture_rect = $NinePatchRect
@onready var text_content = $NinePatchRect/MarginContainer/Text

@export_category("Text cofiguration")
@export var button_text : String = ""
@export var font_size : int = 20

@export_category("Textures")
@export var normal_texture : Texture2D
@export var hover_texture : Texture2D
@export var pressed_texture : Texture2D

var state : Enums.ui_button_state

signal button_clicked

func _ready() -> void:
	set_button_state(Enums.ui_button_state.NORMAL)
	text_content.text = button_text
	text_content.add_theme_font_size_override("font_size",font_size)


func set_button_state(new_state : Enums.ui_button_state):
	state = new_state
	change_texture()
	
func change_texture():
	match state:
		Enums.ui_button_state.NORMAL:
			if normal_texture:
				texture_rect.texture = normal_texture
		Enums.ui_button_state.HOVERED:
			if hover_texture:
				texture_rect.texture = hover_texture
		Enums.ui_button_state.SELECTED:
			if pressed_texture:
				texture_rect.texture = pressed_texture

func _on_mouse_entered() -> void:
	set_button_state(Enums.ui_button_state.HOVERED)


func _on_mouse_exited() -> void:
	set_button_state(Enums.ui_button_state.NORMAL)


func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			set_button_state(Enums.ui_button_state.SELECTED)
			button_clicked.emit()
		if event.button_index == MOUSE_BUTTON_LEFT and not event.pressed:
			set_button_state(Enums.ui_button_state.NORMAL)

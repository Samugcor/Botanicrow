extends TextureRect

var noteBookBackgroundSpread = preload("res://Notebook/Sprites/UI_comparativa_cuaderno_placeholder_open.png")
var noteBookBackgroundHalf = preload("res://Notebook/Sprites/UI_comparativa_cuaderno_placeholder.png")


@export var data: NotebookClass
func _ready() -> void:
	pass
	#get notebook from GameState
	
func activate(mode : Enums.ui_notebook_mode):
	pass
	#check current mode and set background
	
	
	

func setBackground():
	pass
	#if data.current_mode == data.mode.HALF:
	#	texture = noteBookBackgroundHalf
	#else:
	#	texture = noteBookBackgroundSpread
		

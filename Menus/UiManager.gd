extends Control

@onready var hudReference = $CanvasLayer/Hud
@onready var dialogUiReference = $CanvasLayer/DialogUi
@onready var playerMenuReference = $CanvasLayer/PlayerMenu

func _ready() -> void:
	GameplayState.gameplay_state_changed.connect(_on_gameplay_state_changed)

func _on_gameplay_state_changed(system):
	match system:
		dialogUiReference:
			hudReference.visible = false
		playerMenuReference:
			hudReference.visible = false
		_:
			hudReference.visible = true

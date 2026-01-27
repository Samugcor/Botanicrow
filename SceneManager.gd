extends Node2D

@onready var player = $Ysortting/PlayerCharacter
@onready var hud = $Hud

func _ready() -> void:
	player.interaction_prompt.connect(hud._on_prompt)
	player.warning_prompt.connect(hud._on_warning)

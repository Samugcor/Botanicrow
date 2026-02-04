extends Node

signal intent_interact
signal intent_move(axis)

func _physics_process(_delta: float) -> void:
	var axis = Input.get_vector("move_left","move_right","move_up","move_down")
	intent_move.emit(axis)
	

func _unhandled_input(event):
	if event.is_action_pressed("interact"):
		intent_interact.emit()

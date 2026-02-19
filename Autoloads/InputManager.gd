extends Node

signal intent_interact
signal intent_player_menu
signal intent_move(axis)
signal intent_ui_move
signal intent_click_left

func _physics_process(_delta: float) -> void:
	var axis = Input.get_vector("move_left","move_right","move_up","move_down")
	intent_move.emit(axis)
	
func _input(event):
	if event.is_action_pressed("ui_right"):
		print("UP reached InputManager (_input)")	

func _unhandled_input(event):
	if event.is_action_pressed("interact"):
		intent_interact.emit()
		
	var dir := Vector2i.ZERO
	if event.is_action_pressed("ui_left"):  dir = Vector2i.LEFT
	elif event.is_action_pressed("ui_right"): dir = Vector2i.RIGHT
	elif event.is_action_pressed("ui_up"): dir = Vector2i.UP
	elif event.is_action_pressed("ui_down"): dir = Vector2i.DOWN
	
	if dir != Vector2i.ZERO:
		print("sigal emited from unhandled")
		emit_signal("intent_ui_move", dir)

	if event.is_action_released("inventario"):
		intent_player_menu.emit()

	if event.is_action_pressed("click_left"):
		intent_click_left.emit()

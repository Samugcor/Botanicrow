extends Node

signal gameplay_state_changed(system)
var stack := []

func push(system):
	stack.append(system)
	gameplay_state_changed.emit(current())
	print(current())

func pop():
	stack.pop_back()
	gameplay_state_changed.emit(current())
	print(current())

func current():
	return stack.back() if stack.size() > 0 else null

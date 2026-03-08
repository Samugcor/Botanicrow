extends Node

signal gameplay_state_changed(system)
var stack := []

func push(system):
	stack.append(system)
	gameplay_state_changed.emit(current())
	print_rich("[color=cyan]Current gameplay state: [/color]",current())

func pop():
	stack.pop_back()
	gameplay_state_changed.emit(current())
	print_rich("[color=cyan]Current gameplay state: [/color]", current())

func current():
	return stack.back() if stack.size() > 0 else null

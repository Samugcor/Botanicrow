extends Node

var stack := []

func push(system):
	stack.append(system)
	print("GameplayState: ", stack)

func pop():
	stack.pop_back()
	print("GameplayState: ", stack)

func current():
	return stack.back() if stack.size() > 0 else null

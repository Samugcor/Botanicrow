extends Node

var stack := []

func push(system):
	stack.append(system)

func pop():
	stack.pop_back()

func current():
	return stack.back() if stack.size() > 0 else null

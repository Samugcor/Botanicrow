extends Node

var stack := []

func push(system):
	stack.append(system)
	print("pushed", system)
	print("current stack", stack)

func pop():
	stack.pop_back()
	print("popped")
	print("current stack", stack)

func current():
	return stack.back() if stack.size() > 0 else null

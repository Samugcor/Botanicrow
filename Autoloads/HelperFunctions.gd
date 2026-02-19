extends Node

func vectorToPreviousOrNext(vector:Vector2):
	if vector == Vector2.ZERO:
		return 0
	
	if abs(vector.x) > abs(vector.y):
		if vector.x>0:
			return 1
		else:
			return -1
	else:
		if vector.y>0:
			return -1
		else:
			return 1
			
func vectorToVectorDirection(vector:Vector2):
	if abs(vector.x) > abs(vector.y):
		if vector.x>0:
			return Vector2.RIGHT
		else:
			return Vector2.LEFT
	else:
		if vector.y>0:
			return Vector2.UP
		else:
			return Vector2.DOWN

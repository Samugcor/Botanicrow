extends Sprite2D

func update_facing_direction(direction: Vector2):
	if direction.x == 0:
		return
	self.flip_h = direction.x > 0

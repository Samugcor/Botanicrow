extends CharacterBody2D

@export var MAX_SPEED = 400
@export var ACCELERATION = 1500
@export var FRICTION = 1200


func _physics_process(delta):
	handle_movement(delta)

func handle_movement(delta):
	var axis = Input.get_vector("move_left","move_right","move_up","move_down")
	
	if axis == Vector2.ZERO:
		apply_friction(FRICTION * delta)
	else:
		apply_movement(axis * ACCELERATION * delta)
		
	move_and_slide()
		
func apply_friction(nFriction):
	velocity = velocity.move_toward(Vector2.ZERO, nFriction)
		
func apply_movement(nAcceleration):
	velocity += nAcceleration
	velocity = velocity.limit_length(MAX_SPEED)

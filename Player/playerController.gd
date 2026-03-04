extends CharacterBody2D

@export var MAX_SPEED = 400
@export var ACCELERATION = 1500
@export var FRICTION = 1200
@export var inventory:InventoryClass

var movement_axis : Vector2
var posible_interactables = []
var current_interactable = null

@onready var player_view = $Sprite2D

signal new_current_interactable(interacatable)
signal picked_up(item)
signal unable_to_pick

func _ready():
	
	GameplayState.push(self)
	
	InputManager.intent_move.connect(_on_move_intent)
	InputManager.intent_interact.connect(_on_interact_intent)
	#InputManager.intent_player_menu.connect()
	
#Movement
func _physics_process(delta):
	handle_movement(delta)

func _on_move_intent(axis:Vector2):
	if GameplayState.current() != self:
		return
	movement_axis = axis 

func handle_movement(delta):
	if movement_axis == Vector2.ZERO:
		apply_friction(FRICTION * delta)
	else:
		apply_movement(movement_axis * ACCELERATION * delta)
		player_view.update_facing_direction(movement_axis)
		
	move_and_slide()

func apply_movement(nAcceleration):
	velocity += nAcceleration
	velocity = velocity.limit_length(MAX_SPEED)
	
func apply_friction(nFriction):
	velocity = velocity.move_toward(Vector2.ZERO, nFriction)

func reset_movement():
	velocity = Vector2.ZERO
	movement_axis = Vector2.ZERO

#Interaction
func _on_interact_intent():
	if GameplayState.current() != self:
		return
		
	if current_interactable:
		current_interactable.interact(self)
		
func add_interactable(obj):
	if obj not in posible_interactables:
		posible_interactables.append(obj)
		set_current_interactable()
	
func remove_interactable(obj):
	if obj in posible_interactables:
		posible_interactables.erase(obj)
		set_current_interactable()
	
func set_current_interactable():
	print(posible_interactables)
	if  posible_interactables.is_empty():
		current_interactable = null
		new_current_interactable.emit(current_interactable)
		return
		
	if current_interactable and current_interactable.has_method("unmark_as_current_interactable"):
		current_interactable.unmark_as_current_interactable()
	current_interactable = get_closest_interactable()
	if current_interactable.has_method("mark_as_current_interactable"):
		current_interactable.mark_as_current_interactable()
	new_current_interactable.emit(current_interactable)
	
func get_closest_interactable():
	var closest = null
	var min_dist = INF
	for obj in posible_interactables:
		var d = global_position.distance_to(obj.global_position)
		if d < min_dist:
			min_dist = d
			closest = obj
	return closest

#ACTIONS
func pick_up(item:PlantClass):
	var success = inventory.add_item(item)
	#señal pick up para sonidos
	if success:
		picked_up.emit(item)
		current_interactable.remove_self()
		set_current_interactable()
	else:
		unable_to_pick.emit()
		

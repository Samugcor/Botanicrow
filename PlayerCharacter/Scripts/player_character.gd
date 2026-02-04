extends CharacterBody2D

@export var MAX_SPEED = 400
@export var ACCELERATION = 1500
@export var FRICTION = 1200
@export var inventory:InventoryClass

var posible_interactables = []
var current_interactable = null

var moevement_axis : Vector2


signal interaction_prompt(text, visible)
signal warning_prompt(text, visible)

func _ready() -> void:
	GameplayState.push(self)
	InputManager.intent_interact.connect(_on_interact_intent)
	InputManager.intent_move.connect(_on_move_intent)
	
func _physics_process(delta):
	handle_movement(delta)

# MOVIMIENTO =========================================================
func _on_move_intent(axis:Vector2):
	if GameplayState.current() != self:
		return
	moevement_axis = axis 
	
func handle_movement(delta):
	if moevement_axis == Vector2.ZERO:
		apply_friction(FRICTION * delta)
	else:
		apply_movement(moevement_axis * ACCELERATION * delta)
		
	move_and_slide()
	if current_interactable:
		set_current_interactable()
		
func apply_friction(nFriction):
	velocity = velocity.move_toward(Vector2.ZERO, nFriction)
		
func apply_movement(nAcceleration):
	velocity += nAcceleration
	velocity = velocity.limit_length(MAX_SPEED)

# INTERACIIONES =====================================================
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
	if  posible_interactables.is_empty():
		current_interactable = null
		emit_signal("interaction_prompt", "", false)
		return
	
	current_interactable = get_closest_interactable()
	if current_interactable.is_in_group("Pickable"):
		emit_signal("interaction_prompt", TextVariables.PICK_UP, true)
	else:
		emit_signal("interaction_prompt", TextVariables.PRESS_E, true)
	
func get_closest_interactable():
	var closest = null
	var min_dist = INF
	for obj in posible_interactables:
		var d = global_position.distance_to(obj.global_position)
		if d < min_dist:
			min_dist = d
			closest = obj
	return closest

#ACTIONS ==========================================================
func pick_up(item:PlantClass):
	var success = inventory.add_item(item)
	print(success)
	if success:
		current_interactable.remove_self()
		set_current_interactable()
	else:
		emit_signal("warning_prompt", TextVariables.INVENTORY_FULL, true)
		await get_tree().create_timer(1.0).timeout
		emit_signal("warning_prompt", TextVariables.INVENTORY_FULL, false)

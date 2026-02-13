extends Node2D

@onready var environment_container = $World/Enviroment
@onready var player = $World/PlayerCharacter
@onready var camera =  $World/PlayerCharacter/Camera2D2

var current_level: Node = null

func  _ready() -> void:
	loadEnviroment(GameState.current_level_path,GameState.current_spawn_id,false)

func request_enviroment_change(scene_path: String, spawn_id: String):
	call_deferred("loadEnviroment", scene_path, spawn_id)

func loadEnviroment(scene_path: String, spawn_id: String, sart_transition: bool = true, end_transition: bool = true) -> void:
	player.reset_movement()
	Transition.add_to_gaplay_state()
	if sart_transition:
		await Transition.play_start_transition(Transition.TransitionType.FADE_IN)
	
	if scene_path == "" or scene_path == "res://":
		push_error("Invalid scene_path: '" + scene_path + "'")
		return
	# Remove previous level if it exists
	if current_level and is_instance_valid(current_level):
		current_level.queue_free()
		current_level = null
		await get_tree().process_frame

	# Load PackedScene
	var packed: PackedScene = load(scene_path)
	if packed == null:
		push_error("Could not load scene: " + scene_path)
		return

	# Instantiate and add to container
	current_level = packed.instantiate()
	environment_container.add_child(current_level)
		
	# Move player to spawn point
	movePlayerToSpawn(spawn_id)
	
	#Apply camera conf
	apply_camera_configuration()
	
	
	await get_tree().physics_frame
	
	if end_transition:
		await Transition.play_end_transition(Transition.TransitionType.FADE_OUT)
	Transition.remove_from_gaplay_state()
	
func movePlayerToSpawn(spawn_id: String) -> void:
	if current_level == null:
		push_error("No enviroment loaded")
		return

	#Find spawners
	var spawnContainer = current_level.get_node_or_null("SpawnPoints")
	if !spawnContainer:
		push_error("No spawn container found in ",current_level.name )
		return
		
	var spawn = spawnContainer.get_node_or_null(spawn_id) as Marker2D
	if !spawn:
		push_warning("No spawn " + spawn_id + " found in " + current_level.name )
		return

	player.global_position = spawn.global_position
	player.reset_movement()
	
func apply_camera_configuration():
	var cameraConfiguration = current_level.get_node_or_null("cameraConfiguration")
	if cameraConfiguration:
		print("camera blocked")
		camera.limit_enabled = true
		return
		
	print("camera unblocked")
	camera.limit_enabled = false
	

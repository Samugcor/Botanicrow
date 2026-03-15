extends Node
 
const SAVE_PATH_JSON: String  = "user://save_files/savegame.json"
const SAVE_PATH_BINARY: String = "user://save_files/savegame.save"

const KEY_NEW_GAME_BOOL: String = "is_new_game"
const KEY_INV_SIZE: String = "inv_size"
const KEY_CURRENT_SCENE: String = "current_scene"
const KEY_PLAYER_LOC: String = "current_coordinates"
const KEY_PLAYER_LOC_X: String = "player_loc_x"
const KEY_PLAYER_LOC_Y: String = "player_loc_y"
const KEY_INVENTORY: String = "inventory"
const KEY_ACHIVEMENTS: String = "achivements"
const KEY_UNLOCKED_AREAS: String = "unlocked_areas"
const KEY_KNOWN_PLANTS: String = "known_plants"
const KEY_NPCS: String = "npcs"
const KEY_CURRENT_QUEST: String = "current_quest"
const KEY_QUESTS: String = "quests"

const save_dictionary_keys = [
	KEY_NEW_GAME_BOOL,
	KEY_INV_SIZE,
	KEY_CURRENT_SCENE,
	KEY_PLAYER_LOC,
	KEY_PLAYER_LOC_X,
	KEY_PLAYER_LOC_Y,
	KEY_INVENTORY,
	KEY_ACHIVEMENTS,
	KEY_UNLOCKED_AREAS,
	KEY_KNOWN_PLANTS,
	KEY_NPCS,
	KEY_CURRENT_QUEST,
	KEY_QUESTS
]
enum AREAS {
	HOUSE,
	HOUSE_EXTERIOR
}

#References
var player_reference

#DATA FOR SAVING
var new_game:bool = true
var inv_size:int = 12

#Level Data
var current_level_path: String = "res://Escenas/CasaBruja.tscn"
var current_coordinates: Vector2 = Vector2.ZERO

#Player
var inventory: InventoryClass = InventoryClass.new("playerinventory",12)
var achivements: Array = []
var unlockedAreas: Array[AREAS]
var known_plants: Array = [] #plant_id
var npcs: Dictionary = {} # {npc_id : known(bool)}

#Quests
var current_tracked_quest: String: #id
	set(value):
		current_tracked_quest=value
		print("CURRENT TRACKED QUEST", value)
var quests: Dictionary = {} # {quest_id : QuestRuntime}		


#SAVING AND LOADING FUNCTIONS
func newGame():
	new_game = true
	inv_size=12
	current_level_path = "res://Escenas/CasaBruja.tscn"
	current_coordinates = Vector2.ZERO
	inventory = InventoryClass.new("playerinventory",12)
	achivements = []
	unlockedAreas = [AREAS.HOUSE]
	known_plants = [] 
	npcs = {} 
	current_tracked_quest=""
	quests = {}

func save_data_to_json():
	current_coordinates = player_reference.position
	
	var quests_save = {}
	for quest in quests:
		quests_save[quest] =  quests[quest].to_dictionary()
		
	var save_data:Dictionary = {
		KEY_NEW_GAME_BOOL: new_game,
		KEY_INV_SIZE:inv_size,
		KEY_CURRENT_SCENE: current_level_path,
		KEY_PLAYER_LOC_X: current_coordinates.x,
		KEY_PLAYER_LOC_Y: current_coordinates.y,
		KEY_INVENTORY: inventory.to_dictionary(),
		KEY_ACHIVEMENTS: achivements.duplicate(), 
		KEY_UNLOCKED_AREAS: unlockedAreas.duplicate(),
		KEY_KNOWN_PLANTS: known_plants.duplicate(),
		KEY_NPCS: npcs.duplicate(),
		KEY_CURRENT_QUEST: current_tracked_quest,
		KEY_QUESTS: quests_save
	}

	var err:Error = FileHandler.store_json_file(save_data,SAVE_PATH_JSON, true)
	if err != OK:
		push_error("Could not save player data (JSON): ",error_string(err))
		return
	print("Game saved")

func save_data_to_binary():
	current_coordinates = player_reference.position
	
	var save_data:Dictionary = {
		KEY_NEW_GAME_BOOL: new_game,
		KEY_INV_SIZE:inv_size,
		KEY_CURRENT_SCENE: current_level_path,
		KEY_PLAYER_LOC: current_coordinates,
		KEY_INVENTORY: inventory.duplicate_deep(),
		KEY_ACHIVEMENTS: achivements.duplicate(), 
		KEY_UNLOCKED_AREAS: unlockedAreas.duplicate(),
		KEY_KNOWN_PLANTS: known_plants.duplicate(),
		KEY_NPCS: npcs.duplicate(),
		KEY_CURRENT_QUEST: current_tracked_quest,
		KEY_QUESTS: quests.duplicate()
	}

	var err:Error = FileHandler.store_binary_file(save_data,SAVE_PATH_BINARY, true)
	if err != OK:
		push_error("Could not save player data (binary): ",error_string(err))

func load_data_json():
	var save_data: Dictionary = {}
	var err: Error = FileHandler.open_json_file(SAVE_PATH_JSON, save_data)
	if err != OK:
		push_error("Could not load save data (JSON): ", error_string(err))
		return
	
	err = verify_save_data_json(save_data)
	if err!= OK:
		push_error("Invalid save file structure")
		return
	
	new_game = save_data[KEY_NEW_GAME_BOOL]
	inv_size = save_data[KEY_INV_SIZE]
	current_level_path = save_data[KEY_CURRENT_SCENE]
	current_coordinates.x = save_data[KEY_PLAYER_LOC_X]
	current_coordinates.y = save_data[KEY_PLAYER_LOC_Y]
	
	var inv_slots_t :Array[InvSlotClass] = []
	for slot in save_data[KEY_INVENTORY].slots:
		if slot.is_empty():
			var emptyinvslot = InvSlotClass.new()
			inv_slots_t.append(emptyinvslot)
			continue
		var invslot = InvSlotClass.new()
		invslot.from_dictionary(slot)
		inv_slots_t.append(invslot)
		
	inventory.set_slots(inv_slots_t) 
	achivements = save_data[KEY_ACHIVEMENTS]
	
	unlockedAreas.clear()
	for area in save_data[KEY_UNLOCKED_AREAS]:
		unlockedAreas.append(int(area))
		
	known_plants = save_data[KEY_KNOWN_PLANTS]
	npcs = save_data[KEY_NPCS]
	current_tracked_quest = save_data[KEY_CURRENT_QUEST]
	
	var quests_save = {}
	for quest in save_data[KEY_QUESTS]:
		var runtime = QuestRuntime.new()
		runtime.from_dictionary(save_data[KEY_QUESTS][quest])
		quests_save[runtime.quest_id] = runtime
	quests.clear()
	quests.assign(quests_save)
	
func load_data_binary():
	var save_data: Dictionary = {}
	var err: Error = FileHandler.open_binary_file(SAVE_PATH_BINARY, save_data)
	if err != OK:
		push_error("Could not load save data (binary): ", error_string(err))
		return
	
	err = verify_save_data_binary(save_data)
	if err!= OK:
		push_error("Invalid save file structure")
		return
	
	new_game = save_data[KEY_NEW_GAME_BOOL]
	inv_size = save_data[KEY_INV_SIZE]
	current_level_path = save_data[KEY_CURRENT_SCENE]
	current_coordinates = save_data[KEY_PLAYER_LOC]
	inventory.set_slots(save_data[KEY_INVENTORY].slots) 
	achivements = save_data[KEY_ACHIVEMENTS]
	unlockedAreas = save_data[KEY_UNLOCKED_AREAS]
	known_plants = save_data[KEY_KNOWN_PLANTS]
	npcs = save_data[KEY_NPCS]
	current_tracked_quest =save_data[KEY_CURRENT_QUEST]
	
	var quests_save = {}
	for quest in save_data[KEY_QUESTS]:
		var runtime = QuestRuntime.new()
		runtime.from_dictionary(quest)
		quests_save[runtime.quest_id] = runtime
	quests.clear()
	quests.assign(quests_save)
	
func verify_save_data_json(save_data: Dictionary) -> Error:
	for key in save_dictionary_keys:
		if key == KEY_PLAYER_LOC: #JSON files dont have this key becouse it is divided in two separate values
			continue
		if not save_data.has(key):
			return ERR_DOES_NOT_EXIST
	return OK

func verify_save_data_binary(save_data: Dictionary) -> Error:
	for key in save_dictionary_keys:
		if key == KEY_PLAYER_LOC_X or key == KEY_PLAYER_LOC_Y: #Binary files dont have this keys becouse it is grouped in a single value
			continue
		if not save_data.has(key):
			return ERR_DOES_NOT_EXIST
	return OK

#DATA ACCESS FUNCTIONS	
func checkCondition(condition:String) -> bool:
	var parts = condition.split(":")
	var type = parts[0]
	var values = parts.slice(1)
	
	for value in values:
		match type:
			"not_met":
				return not npcs.get(value,false)
				
			"quest_not_active":
				return !is_quest_state(value, Enums.quest_state.ACTIVE)
				
			"quest_active_or_completed":
				return true if quests.get(value, false) else false
			
			"quest_completed":
				return is_quest_state(value, Enums.quest_state.COMPLETED)
				
			"no_quest":
				return not quests.get(value,false)
				
	push_warning("Unknown condition: %s" % condition)
	return false

func setNpc(key: String,value: bool):
	npcs[key]=value

func setQuest(key: String,value: QuestRuntime):
	quests[key]=value

func addKnownPlant(id):
	known_plants.append(id)
	
func setQuestState(key: String, state : Enums.quest_state) -> Error:
	if !quests.has(key):
		return ERR_DOES_NOT_EXIST
	quests[key].quest_state = state
	return OK
func setTrackedQUest(id:String):
	current_tracked_quest=id

func getQuestRuntimeDictionary():
	return quests

func getQuestIdsByState(state : Enums.quest_state):
	var valid_ids =[]
	
	for key in quests:
		var quest_runtime = quests[key]
		if quest_runtime.quest_state == state:
			valid_ids.append(quest_runtime.quest_id)

	return valid_ids

func getQuestIdsByType(type : Enums.quest_type):
	var valid_ids =[]
	
	for key in quests:
		var quest_runtime = quests[key]
		if quest_runtime.quest_type == type:
			valid_ids.append(quest_runtime.quest_id)

	return valid_ids

func getQuestIdsByTypeAndState(type : Enums.quest_type, state : Enums.quest_state):
	var valid_ids =[]
	
	for key in quests:
		var quest_runtime = quests[key]
		if quest_runtime.quest_type == type and quest_runtime.quest_state == state:
			valid_ids.append(quest_runtime.quest_id)

	return valid_ids

func is_quest_state(id : String , state : Enums.quest_state):
	if !quests.has(id) and state == Enums.quest_state.INACTIVE:
		return true
	elif !quests.has(id) and state != Enums.quest_state.INACTIVE:
		return false
		
	if quests[id].quest_state == state:
		return true
	else :
		return false

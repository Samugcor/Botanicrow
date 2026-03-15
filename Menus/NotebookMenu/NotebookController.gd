extends SubmenuController

@onready var view_reference = $NotebookUi

signal page_changed

#	ALL_QUESTS,
#	PLANTS,
#	MAP


enum ntb_sections{
	ACTIVE_QUESTS,
	PLANTS,
	SETTINGS
}

var notebook_content ={}
var current_section_key: int = 0
var current_page:int = 0 #index

var is_at_beggining : bool
var is_at_end : bool

func _ready() -> void:
	super()
	if view_reference.notebook_type == "Spread":
		view_reference.new_tracked_quest_intent.connect(_on_new_tracked_quest_intent)
	
	set_notebook_content()
	
	current_section_key = 0
	current_page = wrapi( notebook_content[current_section_key].find(QuestManager.get_tracked_quest_data()), 0, notebook_content[current_section_key].size())
	

	check_beggining_or_end()
	set_notebook_view()
	set_page_button_view()
	
	
	
func set_section_and_page( section = 0 , page = 0):
	current_section_key = wrapi(section, 0, notebook_content.size())
	current_page = wrapi(page , 0, notebook_content[current_section_key].size())
	
	check_beggining_or_end()
	set_page_button_view()
	set_notebook_view()

#NOTEBOOK CONTENT DATA	
func set_notebook_content():
	if view_reference.notebook_type == "Spread":
		add_active_quests_section()
		add_known_plants_section()
		add_settings_section()
		return
	
	if view_reference.notebook_type == "Half":
		add_active_quests_section()
		add_known_plants_section()

		return
		
	push_error("Unknown notebook type")
	
#Active quest section ______________________________________________________

func add_active_quests_section():
	connect_or_disconect_signals_active_quest_section(true)
	notebook_content[ntb_sections.ACTIVE_QUESTS]=QuestManager.get_quests_data_by_state(Enums.quest_state.ACTIVE)

func connect_or_disconect_signals_active_quest_section(b:bool):
	if b:
		QuestManager.new_tracked_quest.connect(_on_new_tracked_quest)
		QuestManager.quest_started.connect(_update_active_quests_section)
		QuestManager.quest_completed.connect(_update_active_quests_section)
	else:
		QuestManager.new_tracked_quest.disconnect(_on_new_tracked_quest)
		QuestManager.quest_started.disconnect(_update_active_quests_section)
		QuestManager.quest_completed.disconnect(_update_active_quests_section)
	
#Settings section ___________________________________________________________
func add_settings_section():
	notebook_content[ntb_sections.SETTINGS]	= [0]

#Known plants section _______________________________________________________
func add_known_plants_section():
	connect_or_disconect_signals_plants_section(true)
	notebook_content[ntb_sections.PLANTS] = PlantMAnager.get_data_of_known_plants()

func connect_or_disconect_signals_plants_section(b:bool):
	if b:
		PlantMAnager.new_known_plant.connect(_update_known_plants_section)
	else:
		PlantMAnager.new_known_plant.disconnect(_update_known_plants_section)
#Map plants section _________________________________________________________
func add_map_section():
	pass


# Utility____________________________________________________________________
func get_current_page_data():
	if notebook_content[current_section_key].is_empty():
		return null
	return notebook_content[current_section_key][current_page]

func check_beggining_or_end():
	if current_page == 0 and current_section_key == 0:
		is_at_beggining = true
	else:
		is_at_beggining = false
		
	if current_section_key == notebook_content.keys()[-1]:
		if notebook_content[current_section_key].is_empty() or current_page == notebook_content[current_section_key].size()-1:
			is_at_end = true
		else:
			is_at_end = false
	else:
			is_at_end = false		
	
	print_rich("[color=green] is_at_beggining: " + str(is_at_beggining) + " - is_at_end: " + str(is_at_end) + "[/color]")
		
#VIEW FUNCTIONS_________________________________________________________________
func set_notebook_view():
	if notebook_content.is_empty():
		return
	
	print_rich("[color=yellow] Current section: " + str(current_section_key) + " - current page: " + str(current_page) + "[/color]")

	match current_section_key:
		ntb_sections.ACTIVE_QUESTS:
			if notebook_content[ntb_sections.ACTIVE_QUESTS].is_empty():
				view_reference.set_no_items_in_quest_section_view() #Una forma distinta para cada interfaz de decir que no hay nada
				return
				
			if view_reference.notebook_type == "Spread":
				view_reference.set_list_of_active_quests_view(notebook_content[current_section_key], current_page)
			
			view_reference.set_quest_details(notebook_content[ntb_sections.ACTIVE_QUESTS][current_page])
		
		ntb_sections.SETTINGS:
			if view_reference.has_method("set_settings_view"):
				view_reference.set_settings_view()	

		ntb_sections.PLANTS:
			if notebook_content[ntb_sections.PLANTS].is_empty():
				view_reference.set_not_known_plants()
				return
				
			view_reference.set_known_plant_view(notebook_content[ntb_sections.PLANTS][current_page])
		_:
			push_error("No section found")

func update_active_quests_section_view(update_quest_list:bool, update_quest_details:bool):
	print_rich("[color=yellow] Current section: " + str(current_section_key) + " - current page: " + str(current_page) + "[/color]")

	if notebook_content[ntb_sections.ACTIVE_QUESTS].is_empty():
		view_reference.set_no_items_in_quest_section_view() #Una forma distinta para cada interfaz de decir que no hay nada
		return
				
	if view_reference.notebook_type == "Spread" and update_quest_list == true:
		view_reference.set_list_of_active_quests_view(notebook_content[current_section_key], current_page)
	
	if 	update_quest_details == true:
		view_reference.set_quest_details(notebook_content[ntb_sections.ACTIVE_QUESTS][current_page])
		
func set_page_button_view():
	#print_rich("[color=green] Is at beggining: "+ str(is_at_beggining) + " - Is at end: " + str(is_at_end)+"[/color]")
	if is_at_beggining:
		view_reference.set_previous_page_visibility(false)
	else: 	
		view_reference.set_previous_page_visibility(true)
	
	if is_at_end:
		view_reference.set_next_page_visibility(false)
	else:
		view_reference.set_next_page_visibility(true)
		
#ON_ACTION_FUNCTIONS____________________________________________________________
#Notebook
func _on_previous_page_pressed() -> void:
	MusicManager.play_sound_effect(MusicManager.SE_TURN_PAGE)
	var previous_page = current_page - 1 
	if previous_page < 0:
		current_section_key = wrapi(current_section_key -1, 0, notebook_content.size() )
		current_page = wrapi( notebook_content[current_section_key].size()-1, 0,notebook_content[current_section_key].size() )
	else:
		current_page = previous_page
		
	check_beggining_or_end()
	set_page_button_view()
	set_notebook_view()
	page_changed.emit()
	
func _on_next_page_pressed() -> void:
	MusicManager.play_sound_effect(MusicManager.SE_TURN_PAGE)
	var next_page = current_page + 1
	if next_page > notebook_content[current_section_key].size()-1:
		current_section_key = current_section_key + 1
		current_page = 0
	else:
		current_page = next_page
	
	check_beggining_or_end()
	set_page_button_view()
	set_notebook_view()
	page_changed.emit()
	
#Quests
func _on_new_tracked_quest_intent(index: int): #Signal from view
	var quest_data = QuestManager.get_quest_data_by_id(notebook_content[ntb_sections.ACTIVE_QUESTS][index].quest_id)
	QuestManager.setTrackedQuest(quest_data) 
	
func _on_new_tracked_quest(quest_data): #Signal from QuestManager
	if !notebook_content.has(ntb_sections.ACTIVE_QUESTS):
		return
	if current_section_key != ntb_sections.ACTIVE_QUESTS:
		return
	if !quest_data:
		return
		
	var i = notebook_content[ntb_sections.ACTIVE_QUESTS].find(quest_data)
	if i == -1:
		return
	current_page = wrap(i,0,notebook_content[ntb_sections.ACTIVE_QUESTS].size())
	update_active_quests_section_view(false,true)
	
func _update_active_quests_section(_id): #Signal from QuestManager for new or completed quests
	#Por si se actualiza y cambia el orden de las páginas que el jugador siga estando en el mismo sitio
	#if current_section_key == ntb_sections.ACTIVE_QUESTS and !notebook_content[ntb_sections.ACTIVE_QUESTS].is_empty():
		#guardamos la quest
	#	var quest_to_hold = notebook_content[ntb_sections.ACTIVE_QUESTS][current_page]
		#actualizamos datos
	#	notebook_content[ntb_sections.ACTIVE_QUESTS]=QuestManager.get_quests_data_by_state(Enums.quest_state.ACTIVE)
		#buscamos quest en los nuevos datos y asignamos otra vez la pagina
	#	current_page = notebook_content[ntb_sections.ACTIVE_QUESTS].find(quest_to_hold)
	#else:
	notebook_content[ntb_sections.ACTIVE_QUESTS]=QuestManager.get_quests_data_by_state(Enums.quest_state.ACTIVE)
	if current_page > notebook_content[ntb_sections.ACTIVE_QUESTS].size() -1:
		current_page=0
	
	check_beggining_or_end()
	set_notebook_view()
	set_page_button_view()

#Plants
func _update_known_plants_section():
	
	print("_update_plants section")
	if current_section_key == ntb_sections.PLANTS and !notebook_content[ntb_sections.PLANTS].is_empty():
		var plant_to_hold = notebook_content[ntb_sections.PLANTS][current_page]
		notebook_content[ntb_sections.PLANTS] = PlantMAnager.get_data_of_known_plants()
		current_page = notebook_content[ntb_sections.PLANTS].find(plant_to_hold)
	else:
		notebook_content[ntb_sections.PLANTS] = PlantMAnager.get_data_of_known_plants()

	check_beggining_or_end()
	set_notebook_view()
	set_page_button_view()

#Settings
func _on_button_save_button_clicked() -> void:
	
	GameState.save_data_to_json()
	GameState.save_data_to_binary()

	await get_tree().create_timer(1.0).timeout
	MusicManager.play_sound_effect(MusicManager.SE_SUCCESS)
	
	
func _on_button_exit_button_clicked() -> void:
	get_tree().quit() 

func _on_button_options_button_clicked() -> void:
	view_reference.set_option_menu_visibility(true)

extends SubmenuController

@onready var view_reference = $NotebookUi


#	ALL_QUESTS,
#	PLANTS,
#	MAP,
enum ntb_sections{
	ACTIVE_QUESTS,
	SETTINGS
}

var notebook_content ={}
var current_section_key 
var current_page #index

var is_at_beggining : bool
var is_at_end : bool

func _ready() -> void:
	super()
	
	current_section_key = ntb_sections.ACTIVE_QUESTS
	current_page = 0
	is_at_beggining = true
	is_at_end = false
	set_notebook_content()
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
		view_reference.active_mision_selected.connect(_on_active_mision_selected)
		add_active_quests_section()
		add_settings_section()
		return
	
	if view_reference.notebook_type == "Half":
		add_active_quests_section()

		return
		
	push_error("Unknown notebook type")
	
func add_active_quests_section():
	QuestManager.quest_started.connect(_update_active_quests_section)
	notebook_content[ntb_sections.ACTIVE_QUESTS]=QuestManager.get_quests_data_by_state(Enums.quest_state.ACTIVE)

func _update_active_quests_section(_id):
	notebook_content[ntb_sections.ACTIVE_QUESTS]=QuestManager.get_quests_data_by_state(Enums.quest_state.ACTIVE)
	set_notebook_view()

func add_settings_section():
	notebook_content[ntb_sections.SETTINGS]	= [0]
	
func add_known_plants_section():
	pass

func add_map_section():
	pass

func get_current_page_data():
	return notebook_content[current_section_key][current_page]



# CHECK
func check_beggining_or_end():
	if current_page == 0 and current_section_key == 0:
		is_at_beggining = true
	else:
		is_at_beggining = false
		
	if current_section_key == notebook_content.size()-1:
		if current_page == notebook_content[current_section_key].size()-1:
			is_at_end = true
		else:
			is_at_end = false
	else:
			is_at_end = false		
			
#VIEW FUNCTIONS
func set_notebook_view():
	#print_rich("[color=cyan] Current section: " + str(current_section_key) + " - current page: " + str(current_page) + "[/color]")
	if view_reference.notebook_type == "Spread":
		match current_section_key:
			ntb_sections.ACTIVE_QUESTS:
				#print_rich("[color=cyan] aka: active quests[/color]")

				view_reference.set_active_quests_view(notebook_content[current_section_key])
				return
			ntb_sections.SETTINGS:
				#print_rich("[color=cyan] aka: settings[/color]")
				view_reference.set_settings_view()
				return
			_:
				push_error("No section found")
				return
		
	if view_reference.notebook_type == "Half":
		match current_section_key:
			ntb_sections.ACTIVE_QUESTS:
				view_reference.set_quest_details(get_current_page_data())
				return
			_:
				push_error("No section found")
				return
		
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
		
		
#ON ACTION FUNCTIONS
func _on_active_mision_selected(index: int):
	if notebook_content[ntb_sections.ACTIVE_QUESTS].is_empty():
		push_warning("no misions to be selected")
		return
	view_reference.set_quest_details(notebook_content[ntb_sections.ACTIVE_QUESTS][index])
	GameState.current_tracked_quest = notebook_content[ntb_sections.ACTIVE_QUESTS][index].quest_id

func _on_button_save_button_clicked() -> void:
	GameState.save_data_to_json()
	GameState.save_data_to_binary()
	
func _on_button_exit_button_clicked() -> void:
	get_tree().quit() 

func _on_previous_page_pressed() -> void:
	var previous_page = current_page - 1 
	if previous_page < 0:
		current_section_key = current_section_key -1
		current_page = wrapi( notebook_content[current_section_key].size()-1, 0,notebook_content[current_section_key].size() )
	else:
		current_page = previous_page
		
	check_beggining_or_end()
	set_page_button_view()
	set_notebook_view()
	
func _on_next_page_pressed() -> void:
	var next_page = current_page + 1
	if next_page > notebook_content[current_section_key].size()-1:
		current_section_key = current_section_key + 1
		current_page = 0
	else:
		current_page = next_page
	
	check_beggining_or_end()
	set_page_button_view()
	set_notebook_view()

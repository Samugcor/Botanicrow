extends SubmenuController

@onready var view_reference = $NotebookUi

enum ntb_sections{
	ACTIVE_QUESTS,
	ALL_QUESTS,
	PLANTS,
	MAP
}

var notebook_content ={}
var current_section_key 
var current_page #data object



func _ready() -> void:
	super()
	
	set_notebook_content()
	set_notebook_view()
	
	
func set_notebook_content():
	if view_reference.notebook_type == "Spread":
		view_reference.active_mision_selected.connect(_on_active_mision_selected)
		add_active_quests_section()
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
	set_notebook_view(ntb_sections.ACTIVE_QUESTS)
	
func add_known_plants_section():
	pass

func add_map_section():
	pass

func get_current_page_data():
	return current_page
#View configurations
func set_notebook_view( section = 0, page = 0):
	#Si no hay sección la vista empieza en la primera "página" de la primera sección
	current_section_key = notebook_content.keys()[section]
	
	if notebook_content[current_section_key].is_empty():
		current_page = null
	else:
		current_page = notebook_content[current_section_key][page]
		
	if view_reference.notebook_type == "Spread":
		match current_section_key:
			ntb_sections.ACTIVE_QUESTS:
				view_reference.set_active_quests_view(notebook_content[current_section_key])
				
		return
	if view_reference.notebook_type == "Half":
		match current_section_key:
			ntb_sections.ACTIVE_QUESTS:
				view_reference.set_quest_details(current_page)	
		return
		
func _on_active_mision_selected(index: int):
	if notebook_content[ntb_sections.ACTIVE_QUESTS].is_empty():
		push_warning("no misions to be selected")
		return
	view_reference.set_quest_details(notebook_content[ntb_sections.ACTIVE_QUESTS][index])
	GameState.current_tracked_quest = notebook_content[ntb_sections.ACTIVE_QUESTS][index].quest_id
	

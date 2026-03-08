extends SupermenuController

@onready var menu_view = $Control

@onready var cauldron_controler = $Control/Cauldron
@onready var notebook_controler = $Control/HalfNotebook

var selectedPlant:PlantClass
var cauldron_full

func _ready() -> void:
	super()
	cauldron_controler.cauldron_full_changed_to.connect(_on_cauldron_status_changed)
	cauldron_controler.cauldron_conten_changed.connect(_on_cauldron_conten_changed)
	set_add_cauldron_button_view()
	set_brew_button_view()
	GameplayState.push(self)
	
func set_brew_button_view():
	if !GameState.current_tracked_quest:
		menu_view.set_brew_button_visibility(false)
		return
		
	if cauldron_full:
		menu_view.set_brew_button_visibility(true)
	else:
		menu_view.set_brew_button_visibility(false)
		
func set_add_cauldron_button_view():
	if cauldron_controler.cauldronContents.is_empty():
		menu_view.set_add_button_visibility(false)
		return
	if cauldron_controler.check_cauldron_has(selectedPlant):
		menu_view.set_add_button_visibility(false)
		return
	if cauldron_full or !selectedPlant:
		menu_view.set_add_button_visibility(false)
	else:
		menu_view.set_add_button_visibility(true)
	
func _on_exit_pressed() -> void:
	GameplayState.pop()
	self.queue_free()
	
func _on_cauldron_conten_changed():
	set_add_cauldron_button_view()

func _on_cauldron_status_changed(isfull:bool):
	cauldron_full = isfull
	set_brew_button_view()

func _on_inventory_slot_selected(data_slot: Variant) -> void:
	menu_view.set_plant_detail(data_slot)
	menu_view.set_observations(data_slot)
	selectedPlant = data_slot
	set_add_cauldron_button_view()
	
func _on_add_cauldron_button_pressed() -> void:
	cauldron_controler.add_to_cauldron(selectedPlant)
	set_add_cauldron_button_view()

func _on_brew_pressed() -> void:
	var quest_data = notebook_controler.get_current_page_data() as QuestClass
	var potion_components = []
	
	if  !quest_data:
		push_error("No potion can be brewed without an active quest")
		return
		
	for objective in quest_data.quest_objectives:
		potion_components.append(objective.required_item)

	if cauldron_controler.check_potion(potion_components):
		print_rich("[color=green]Misión completada![/color]")
		QuestManager.completeActiveQuest(quest_data.quest_id)
		menu_view.start_correct_animation()
		return
	else:
		print_rich("[color=red]Algo está mal[/color]")
		menu_view.start_wrong_animarion()

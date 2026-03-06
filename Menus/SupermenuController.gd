extends Node
class_name SupermenuController

var submenu_references :=[]
var current_submenu

func _ready() -> void:
	
	InputManager.mouse_motion.connect(_on_mouse_motion)
	
	
func _on_mouse_motion():
	
	if GameplayState.current() != self:
		return
		
	for submenu in submenu_references:
		if submenu.get_global_rect().has_point(submenu.get_global_mouse_position()):
			if submenu != current_submenu:
				update_current_submenu(submenu)
			return
	if current_submenu != null:
		update_current_submenu(null)
		return
	#push_error("Error in my logic :D submenus are not handled properly")
	
func update_current_submenu(submenu):
	if current_submenu:
		current_submenu.deactivate()
	current_submenu=submenu
	if current_submenu:
		current_submenu.activate()
	
func add_submenu_reference(system):
	submenu_references.append(system)

func remove_submenu_reference(system):
	submenu_references.erase(system)

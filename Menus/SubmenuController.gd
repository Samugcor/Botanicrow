extends Control
class_name SubmenuController

var super_menu_reference: SupermenuController
var is_active : bool = false

func _ready() -> void:
	super_menu_reference =  get_node_or_null("../..") as SupermenuController 
	if super_menu_reference:
		super_menu_reference.add_submenu_reference(self)
	is_active = false
	
func activate():
	is_active = true
	
func deactivate():
	is_active = false

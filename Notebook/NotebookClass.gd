extends Resource
class_name NotebookClass

var current_mode : Enums.ui_notebook_mode
var content : Dictionary[String, Array] #{section:[data}

var current_section #dictionary key
var current_page : int #index

func setNotebookMode(m : Enums.ui_notebook_mode):
	current_mode=m

func addSection(section_name : String):
	if content.has(section_name):
		push_warning("Section already exists")
		return
		
	content[section_name]=[]
	
func addContentToSection(section_name : String, content_array : Array):
	if !content.has(section_name):
		push_error("Section does not exist")
		return
	
	content[section_name].append(content_array)
	 #Como las secciones se inicializan con un array vacio nunca hay problema por mergear los dos

func deleteSection(section_name : String):
	if !content.erase(section_name):
		push_error("Section does not exist")

func goToNextPage():
	current_page =+ 1

func goToPreviousPage():
	current_page =- 1
	
func goToPage(index : int):
	current_page = index
	

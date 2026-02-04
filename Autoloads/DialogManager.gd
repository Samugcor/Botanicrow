extends Node

signal start_dialog()
signal node_changed_dialog(npc_id, text, choices)
signal end_dialog

var dialogue_cache:={}  # id -> parsed dialogue data

#current dialog data
var dialog_data 
var dialog_entry
var dialog_node
var dialog_choices

#current npc data
var npc_id
var file_path

func startNpcDialog(_npc_id,_file_path):
	npc_id = _npc_id
	file_path = _file_path
	#Comprobamos si dialogo está en cache
	dialog_data = getDialogueFromCache()
	
	#Si no está cargamos archivo a caché
	if !dialog_data:
		dialog_data = getFileContents()
		dialogue_cache[npc_id] = dialog_data
		print("Lo cogimos del archivo y lo guardamos en caché")
	
	print("Está en cache")
	#Seleccionamos la entrada correcta(por prioridad y/o condiciones)
	dialog_entry = getCorrespondingDialogEntry()
	
	#if entry has effects apply effects
	if dialog_entry.has("effects"):
		for effec in dialog_entry.effects:
			GameState.applyEffect()
	
	#Coger nodo start
	getDialogNode("start")
	# Signal start to dialog ui
	emit_signal("start_dialog")
	#signal node change with current values
	emit_signal("node_changed_dialog", npc_id, dialog_node.text,dialog_choices)
	
	

func getFileContents():
	
	var data =  FileAccess.get_file_as_string(file_path)
	if !data:
		print(FileAccess.get_open_error())
		return 
	var parsed_data = JSON.parse_string(data)
	if !parsed_data:
		print("error parsing data")
		return
	
	return parsed_data
	
func getDialogueFromCache():
	if dialogue_cache.has(npc_id):
		return dialogue_cache[npc_id]
	
	return 

func getCorrespondingDialogEntry():
	#Sort by priority
	var sorted_entries = dialog_data.entries.duplicate()
	sorted_entries.sort_custom(func(a, b):
		return a.priority > b.priority
	)
	#Una vez ordenadas comprobamos requisitos
	#Devolvemos la primera (más alta prioridad) que cumpla los requisitos
	for entry in sorted_entries:
		for condition in entry.conditions:
			if GameState.checkCondition(condition):
				return entry

func getDialogNode(node_id):
	dialog_node = dialog_entry.nodes.get(node_id,false)
	if node_id == "start" and not dialog_node:
		#get random node
		pass
	dialog_choices = dialog_node.choices if dialog_node.has("choices") else []

func advance(next_node_id: String = ""):
	#Si el nodo actual es el último cerramos dialogo
	if dialog_node.has("end"):
		if dialog_node.end:
			emit_signal("end_dialog")
			return
	
	#Si nos han pasado un id avanzamos hasta ese nodo
	if next_node_id:
		getDialogNode(next_node_id)
		emit_signal("node_changed_dialog", npc_id, dialog_node.text,dialog_choices)
		return
	
	#Si no es final y no nos han indicado siguiente buscamos cual sería el siguiente
	if dialog_node.has("next"):
		getDialogNode(dialog_node.next)
		emit_signal("node_changed_dialog", npc_id, dialog_node.text,dialog_choices)
		return
	
	push_error("The conversation has reached a breaking point")

extends Node

signal start_dialog()
signal node_changed_dialog(npc_id, text, choices)
signal end_dialog

var dialogue_cache:={}  # id -> parsed dialogue data
var seen_dialogs = [] # entri id
#current dialog data
var dialog_data 
var dialog_entry
var dialog_node
var dialog_choices

#current npc data
var npc_data : NpcClass
var npc_portrait

func startNpcDialog(_npc_data : NpcClass):
	npc_data = _npc_data
	npc_portrait = npc_data.NORMAL
	
	#Comprobamos si dialogo está en cache
	dialog_data = getDialogueFromCache()
	
	#Si no está cargamos archivo a caché
	if !dialog_data:
		dialog_data = getFileContents()
		dialogue_cache[npc_data.id] = dialog_data
		
	#Seleccionamos la entrada correcta(pororidad y/o condiciones)
	dialog_entry = getCorrespondingDialogEntry()
	
	seen_dialogs.append(dialog_entry.id)
	
	#if entry has effects apply effects
	if dialog_entry.has("effects"):
		for effect in dialog_entry.effects:
			GameEvents.applyEffect(effect)
	
	#Coger nodo start
	getDialogNode("start")
	# Signal start to dialog ui
	emit_signal("start_dialog")
	#signal node change with current values
	emit_signal("node_changed_dialog", npc_data.id, npc_portrait, dialog_node.text,dialog_choices)
	
func getFileContents():
	
	var data =  FileAccess.get_file_as_string(npc_data.dialogFile)
	if !data:
		push_error("Error FileAccess: ", FileAccess.get_open_error())
		return 
	var parsed_data = JSON.parse_string(data)
	if !parsed_data:
		push_error("error parsing data")
		return
	
	return parsed_data
	
func getDialogueFromCache():
	if dialogue_cache.has(npc_data.id):
		return dialogue_cache[npc_data.id]
	
	return 

func getCorrespondingDialogEntry():
	#Sort by priority
	var sorted_entries = dialog_data.entries.duplicate()
	sorted_entries.sort_custom(func(a, b):
		return a.priority > b.priority
	)
	#Una vez ordenadas comprobamos requisitos y
	#devolvemos la primera (más alta prioridad) que cumpla los requisitos
	for entry in sorted_entries:
		if entry.has("repeat"):
			if entry.repeat == "once":
				if seen_dialogs.has(entry.id):
					continue
			
		
		if entry.conditions.is_empty():
			return entry
			
		var conditions_met = true
		for condition in entry.conditions:
			if !GameState.checkCondition(condition):
				conditions_met = false
				break
				
		if conditions_met:
			return entry
			
func getDialogNode(node_id):
	dialog_node = dialog_entry.nodes.get(node_id,false)
	if node_id == "start" and not dialog_node:
		var rng = RandomNumberGenerator.new()
		node_id = str(rng.randi_range(0, dialog_entry.nodes.size()-1))
		dialog_node = dialog_entry.nodes[node_id]
	
	if dialog_node.has("effects"):
		for effect in dialog_node.effects:
			GameEvents.applyEffect(effect)
	if dialog_node.has("portrait"):
		match dialog_node.portrait:
			"NORMAL" : 
				npc_portrait = npc_data.NORMAL
			"ANGRY": 
				npc_portrait = npc_data.ANGRY
			"SAD":
				npc_portrait = npc_data.SAD
			_:
				npc_portrait = npc_data.NORMAL
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
		emit_signal("node_changed_dialog", npc_data.id, npc_portrait,dialog_node.text,dialog_choices)
		return
	
	#Si no es final y no nos han indicado siguiente buscamos cual sería el siguiente
	if dialog_node.has("next"):
		getDialogNode(dialog_node.next)
		emit_signal("node_changed_dialog", npc_data.id, npc_portrait, dialog_node.text,dialog_choices)
		return
	
	push_error("The conversation has reached a breaking point")

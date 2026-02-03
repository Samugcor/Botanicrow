extends Node

var dialogue_cache:={}  # id -> parsed dialogue data

func startDialog(npc_id,file_path):
	var dialog_data
	
	#Comprobamos si dialogo está en cache
	dialog_data = getDialogueFromCache(npc_id)
	
	#Si no está cargamos archivo a caché
	if !dialog_data:
		dialog_data = getFileContents(file_path)
		dialogue_cache[npc_id] = dialog_data
		print("Lo cogimos del archivo y lo guardamos en caché")
	
	print("Está en cache")
	#Seleccionamos la entrada correcta(por prioridad y/o condiciones)
	getDialogEntry(dialog_data)


func getFileContents(file_path):
	
	var data =  FileAccess.get_file_as_string(file_path)
	if !data:
		print(FileAccess.get_open_error())
		return 
	var parsed_data = JSON.parse_string(data)
	if !parsed_data:
		print("error parsing data")
		return
	
	return parsed_data
	
func getDialogueFromCache(npc_id):
	if dialogue_cache.has(npc_id):
		return dialogue_cache[npc_id]
	
	return 

func getDialogEntry(dialog_data):
	#Sort by priority
	var sorted_entries = dialog_data.entries.duplicate()
	sorted_entries.sort_custom(func(a, b):
		return a.priority > b.priority
	)
	print("ENTRADAS POR PRIORIDAD:")
	print(sorted_entries)
	#Una vez ordenadas comprobamos requisitos
	#Devolvemos la primera (más alta prioridad) que cumpla los requisitos
	

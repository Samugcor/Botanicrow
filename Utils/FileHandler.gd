extends Node
class_name FileHandler


static func store_json_file(data:Dictionary,file_path:String, create_dir: bool) -> Error:
	var result: Array = _open_file_for_write(file_path,create_dir)
	var err: Error = result[0] as Error
	var file: FileAccess = result[1] as FileAccess	
	
	if err != OK:
		return err
		
	file.store_string(JSON.stringify(data))
	file.close()
	return OK

static func store_binary_file(data:Dictionary,file_path:String, create_dir: bool) -> Error:
	var result: Array = _open_file_for_write(file_path,create_dir)
	var err: Error = result[0] as Error
	var file: FileAccess = result[1] as FileAccess	
	
	if err != OK:
		return err
		
	file.store_var(data, false) #El false es importante, relee la docu si te olvidas
	file.close()
	return OK
	
	
static func _open_file_for_write(file_path:String, create_dir:bool) -> Array:
	var err: Error = _check_and_create_directory(file_path,create_dir)
	if err != OK:
		return [err,null]
	
	var file:FileAccess = FileAccess.open(file_path, FileAccess.WRITE)
	if file == null:
		return [FileAccess.get_open_error(),null]
		
	return [OK,file]
	
static func _check_and_create_directory(file_path:String, create_dir:bool) -> Error:
	var dir_path: String =file_path.get_base_dir()
	if DirAccess.dir_exists_absolute(dir_path):
		return OK
	if not create_dir:
		return ERR_CANT_CREATE
	return DirAccess.make_dir_recursive_absolute(dir_path)	

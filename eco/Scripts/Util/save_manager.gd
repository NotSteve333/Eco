@tool
extends Manager
# Manages the creation, editing, and loading of files on disk

var FacadesPaths: Dictionary
var facade_source: String = "res://Saves/Registers/facades_paths.json"

var DataPaths: Dictionary
var data_source: String = "res://Saves/Registers/data_paths.json"

func save_room(facade: RoomFacade) -> void:
	FacadesPaths[facade.facade_id] = str("res://Scenes/Rooms/", facade.facade_id, ".tscn")
	if !facade.get("data"):
		facade.data = create_room_data(facade, facade.data_id)
	var data: RoomData = facade.data
	facade.exits_dict.clear()
	facade.neighbors.clear()
	for e in facade.get_node("Exits").get_children():
		facade.exits_dict.append(e.position)
		if facade.facade_id != e.room_id_1:
			facade.neighbors.append(e.room_id_1)
		else:
			facade.neighbors.append(e.room_id_2)
	data.exits_dict = facade.exits_dict
	data.neighbors = facade.neighbors
	data.data_id = facade.get("data_id")
	data.facade_id = facade.get("facade_id")
	data.camera_bounds = facade.get("camera_bounds")
	data.water_region = facade.get("water_region")
	data.light_region = facade.get("light_region")
	data.temp_region = facade.get("temp_region")
	data.pol_region = facade.get("pol_region")
	data.last_update = facade.get("last_update")
	var filepath: String = str("res://Saves/Rooms/", facade.facade_id, "/", facade.facade_id, ".tres")
	DataPaths[data.data_id] = filepath
	ResourceSaver.save(data, filepath)
	EditorInterface.get_resource_filesystem().update_file(filepath)
	
func save_plant(facade: PlantFacade, room: String) -> PlantData:
	FacadesPaths[facade.facade_id] = str("res://Scenes/Plants/", facade.facade_id, ".tscn")
	if !facade.get("data"):
		facade.data = create_plant_data(facade, room)
	var data: PlantData = facade.data
	data.data_id = facade.get("data_id")
	data.facade_id = facade.get("facade_id")
	data.species_data = get_species_data(data.facade_id)
	facade.room_id = room
	data.room_id = facade.get("room_id")
	facade.position_in_room = facade.get("position")
	data.position_in_room = facade.get("position_in_room")
	data.growth_stage = facade.get("growth_stage")
	var filepath: String = str("res://Saves/Rooms/", room, "/Plants/", data.data_id, ".tres")
	DataPaths[data.data_id] = filepath
	if not FileAccess.file_exists(filepath):
		ResourceSaver.save(data, filepath)
	EditorInterface.get_resource_filesystem().update_file(filepath)
	return data

func get_species_data(species_name: String) -> PlantSpeciesData:
	var filepath = str("res://Saves/PlantSpeciesData/", species_name, ".tres")
	var data: PlantSpeciesData
	if not FileAccess.file_exists(filepath):
		data = PlantSpeciesData.new()
		ResourceSaver.save(data, filepath)
	else:
		data = load(filepath)
	return data

func _ready() -> void:
	load_from_json()
	
func load_plant(data: PlantData) -> PlantFacade:
	var plant_name = data.facade_id
	var new_facade = load(FacadesPaths[plant_name]).instantiate()
	new_facade.data_id = data.data_id
	new_facade.facade_id = data.facade_id
	new_facade.species_data = data.species_data
	new_facade.room_id = data.room_id
	new_facade.position_in_room = data.position_in_room
	new_facade.position = new_facade.position_in_room
	new_facade.name = new_facade.data_id
	new_facade.growth_stage = data.growth_stage
	new_facade.data = data
	return new_facade

func write_to_json() -> void:
	write_dictionary_to_json(FacadesPaths)
	write_dictionary_to_json(DataPaths)
	
func load_from_json() -> void:
	FacadesPaths = load_dictionary_from_json(facade_source)
	DataPaths = load_dictionary_from_json(data_source)

func write_dictionary_to_json(dict: Dictionary) -> void:
	var filepath = dict["source"]
	var json_string = JSON.stringify(dict, "\t")
	var file = FileAccess.open(filepath, FileAccess.WRITE)
	file.store_string(json_string)
	file.close()

func load_dictionary_from_json(source: String) -> Dictionary:
	if not FileAccess.file_exists(source):
		return {"source": source}
	var file = FileAccess.open(source, FileAccess.READ)
	var content = file.get_as_text()
	file.close()
	var result = JSON.parse_string(content)
	return result
	
func create_plant_data(facade: PlantFacade, room: String) -> PlantData:
	var new_data: Data
	var data_path: String
	new_data = PlantData.new()
	data_path = str("res://Saves/Rooms/", room, "/Plants/", facade.data_id, ".tres")
	ResourceSaver.save(new_data, data_path)
	DataPaths[name] = data_path
	return new_data
	
func create_room_data(facade: RoomFacade, room_name: String) -> RoomData:
	var new_data: Data
	var data_path: String
	new_data = RoomData.new()
	data_path = str("res://Saves/Rooms/", facade.facade_id, "/", room_name, ".tres")
	ResourceSaver.save(new_data, data_path)
	DataPaths[name] = data_path
	return new_data

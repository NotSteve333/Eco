extends Node

var active_room: Room
var loaded_rooms: Array[Room]

func load_room(room_id: String) -> void:
	pass
	
func update_loaded_rooms(new_rooms: Array[String]) -> void:
	var new_loaded_rooms: Array[Room] = []
	for r in loaded_rooms:
		var id = r.room_id
		if id in new_rooms:
			new_loaded_rooms.append(r)
			new_rooms.erase(id)
		else:
			r.free()
		loaded_rooms.erase(r)
	for n in new_rooms:
		var new_path = SceneDictionary.RoomScenes[n]
		var new_scene = load(new_path).instantiate()
		new_loaded_rooms.append(new_scene)
	loaded_rooms = new_loaded_rooms

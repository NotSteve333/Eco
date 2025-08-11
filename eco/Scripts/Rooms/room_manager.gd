extends Node
class_name RoomManager

var active_room: Room
var loaded_rooms: Array[Room]

signal spawn_in(spawn_point: Vector2)
signal update_rooms(rooms: Array[Room], time: float)

func change_room(room_id: String, exit_id: String) -> void:
	for r in loaded_rooms:
		if r.room_id == room_id:
			remove_child(active_room)
			r.change_room.connect(change_room)
			update_loaded_rooms(r.get_neighbors(), active_room)
			active_room = r
			add_child(active_room)
			enter_room(exit_id)
			return

func enter_room(exit_id: String) -> void:
	spawn_in.emit(active_room.get_exit_location(exit_id))

func update_loaded_rooms(new_rooms: Array[String], just_left: Room) -> void:
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
		var new_scene: Room
		if n != just_left.room_id:
			var new_path = SceneDictionary.RoomScenes[n]
			new_scene = load(new_path).instantiate()
		else: 
			new_scene = just_left
		new_loaded_rooms.append(new_scene)
	update_rooms.emit(new_loaded_rooms, GlobalTime.get_total_seconds())
	loaded_rooms = new_loaded_rooms

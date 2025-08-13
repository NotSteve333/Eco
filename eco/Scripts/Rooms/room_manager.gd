extends Node
# Managers which rooms are updated and moves the player between them
class_name RoomManager

# Room the player is in
var active_room: Room
# Rooms in scope (adjacent to current)
var loaded_rooms: Array[Room]

# Short room change animation?
signal spawn_in(spawn_point: Vector2)
# Weather/Animal/Plant/Fungi Managers
signal update_rooms(rooms: Array[Room], time: float)

# Change the current room and spawn in the player accordingly
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

# Move rooms, instantiate, and free rooms based on change in scope
# Note: Consider ordering result based on proximity to entrance 
func update_loaded_rooms(new_rooms: Array[String], just_left: Room) -> void:
	var new_loaded_rooms: Array[Room] = []
	
	# Check old scope
	for r in loaded_rooms:
		var id = r.room_id
		
		# Move rooms still in scope
		if id in new_rooms:
			new_loaded_rooms.append(r)
			new_rooms.erase(id)
			
		# Remove rooms which have left scope
		else:
			r.queue_free()
		loaded_rooms.erase(r)
	
	# Add rooms which have entered scope
	for n in new_rooms:
		var new_scene: Room
		if n != just_left.room_id:
			var new_path = SceneDictionary.RoomScenes[n]
			new_scene = load(new_path).instantiate()
			
		# Special case for the room we just left
		else: 
			new_scene = just_left
		new_loaded_rooms.append(new_scene)
	
	# Consider ordering rooms  based on exit distance? Prioritization
	update_rooms.emit(new_loaded_rooms, GlobalTime.get_total_seconds())
	loaded_rooms = new_loaded_rooms

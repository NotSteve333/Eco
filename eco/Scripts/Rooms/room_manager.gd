extends Manager
# Managers which rooms are updated and moves the player between them
class_name RoomManager

# @export var room_update_budget: float = 15000.0

# Room the player is in
var active_room: RoomFacade
# Rooms in scope (adjacent to current).
# Note: Contains RoomData resources.
var loaded_rooms: Dictionary
var load_room_queue: Array[RoomData]
var load_room_queue_amt: int = 15000.0
var max_update_duration: float

# Short room change animation?
signal spawn_in(spawn_point: Vector2)
# Room is ready for plant_manager to process
signal send_room_to_plant_manager(room: RoomData)
# Tell the load manager to free associated assets
signal done_with_room(room_id: String)

func _process(_delta: float) -> void:
	var start_time = Time.get_ticks_usec()
	
	while load_room_queue_amt > 0:
		
		var cur_room = load_room_queue.pop_back()
		cur_room.update()
		load_room_queue_amt -= 1
		
		# Run out of time this frame
		if Time.get_ticks_usec() - start_time >= max_update_duration:
			return

# Change the current room and spawn in the player accordingly
func change_room(room_id: String, exit_id: String) -> void:
	remove_child(active_room)
	var r = loaded_rooms[room_id]
	update_loaded_rooms(r.get_neighbors(), active_room)
	active_room = %LoadManager.need_facade(r)
	active_room.change_room.connect(change_room)
	update_rooms()
	add_child(active_room)
	enter_room(exit_id)
	return

# plant_manager has finished with the plants in this room
func finished_plants(room_id: String) -> void:
	loaded_rooms[room_id].set_last_update(GlobalTime.get_total_seconds())
	%LoadManager.add_data_to_queue(loaded_rooms[room_id])

# Play enter room animation
func enter_room(exit_id: String) -> void:
	spawn_in.emit(active_room.get_exit_location(exit_id))

# Initiate update chain for each room
func update_rooms() -> void:
	for r_id in loaded_rooms:
		load_room_queue.append(loaded_rooms[r_id])

# Tell the plant_manager to start processing plants in this room
func send_plants_to_manager(room_id: String) -> void:
	send_room_to_plant_manager.emit(loaded_rooms[room_id])

# Move rooms, instantiate, and free rooms based on change in scope
# Note: Consider ordering result based on proximity to entrance
func update_loaded_rooms(new_rooms: Array[String], just_left: RoomFacade) -> void:
	var new_loaded_rooms: Dictionary
	
	# Check old scope
	for r_id in loaded_rooms:
		
		# Move rooms still in scope
		if r_id in new_rooms:
			var r = loaded_rooms[r_id]
			r.plants_ready.connect(send_plants_to_manager)
			new_loaded_rooms[r_id] = r
			new_rooms.erase(r_id)
			
		# Remove rooms which have left scope
		else:
			done_with_room.emit(r_id)
		loaded_rooms.erase(r_id)
	
	# Add rooms which have entered scope
	for n in new_rooms:
		var new_scene: RoomData
		if n != just_left.room_id:
			var new_path = SceneDictionary.RoomScenes[n]
			new_scene = load(new_path)
			
		# Special case for the room we just left
		else: 
			new_scene = just_left.get_data()
		new_scene.plants_ready.connect(send_plants_to_manager)
		new_loaded_rooms[n] = new_scene
		
	loaded_rooms = new_loaded_rooms

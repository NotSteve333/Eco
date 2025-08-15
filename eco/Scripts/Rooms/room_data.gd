extends Resource
# Space which entities reside in, screens, levels
class_name RoomData

# Name of room for loading
@export var room_id: String
# Size/Shape of room
@export var camera_bounds: Vector4
# Exits to other rooms
@export var exits_dict: Dictionary
# Watershed region this room resides in
@export var water_region: Region
# Light region this room resides in
@export var light_region: Region
# Temperaure region this room resides in
@export var temp_region: Region
# Polinator region this room resides in
@export var pol_region: Region

# plants in this room
var plants: Array[PlantData]
# Last time this room was updated
var last_update: float
# Historic events since last_update
var conditions_dict: Dictionary

# Player is switching to target via exit_id
signal change_room(target: String, exit_id: String)
signal room_data_ready(id: String)

func update() -> void:
	conditions_dict = combine_conditions()
	room_data_ready.emit(room_id)

func get_region_conditions() -> Dictionary:
	return conditions_dict

func get_local_conditions(pos: Vector2) -> Vector3:
	return Vector3.ZERO
	
# Compile all events into a dictionary of vec4s
func combine_conditions() -> Dictionary:
	var water_events = water_region.get_events_since(last_update, room_id)
	var light_events = light_region.get_events_since(last_update, room_id)
	var temp_events = temp_region.get_events_since(last_update, room_id)
	var pol_events = pol_region.get_events_since(last_update, room_id)
	var combine_events: Dictionary
	var w = 0
	var l = 0
	var t = 0
	var p = 0
	var cur_time: float
	for i in range(water_events.size() + light_events.size() + temp_events.size()):
		var new_cond_vec = Vector3(water_events[w].y, light_events[l].y, temp_events[t].y)
		if water_events[w] < light_events[l] and water_events[w] < temp_events[t] and water_events[w] < pol_events[p]:
			cur_time = water_events[w].x
			w += 1
		elif light_events[l] < water_events[w] and light_events[l] < temp_events[t] and light_events[l] < pol_events[p]:
			cur_time = light_events[l].x
			l += 1
		elif temp_events[t] < water_events[w] and temp_events[t] < light_events[l] and temp_events[t] < pol_events[p]:
			cur_time = temp_events[t].x
			t += 1
		else:
			cur_time = pol_events[p].x
			p += 1
		combine_events[cur_time] = new_cond_vec
	return fix_start_time(last_update, combine_events)

# Cuts out the first chunk of time between
func fix_start_time(start: float, cond_dict: Dictionary) -> Dictionary:
	var dict_start = min(cond_dict.keys())
	if dict_start < start:
		cond_dict[start] = cond_dict[dict_start]
		cond_dict.erase(dict_start)
	return cond_dict

# Returns plants in this room
func get_plants_data() -> Array[PlantData]:
	return plants

func get_last_update() -> float:
	return last_update
	
func set_last_update(time: float) -> void:
	last_update = time

# Gets where the player should enter this room from based on the exit they used
func get_exit_location(exit_id: String) -> Vector2:
	return exits_dict[exit_id].get_spawn_point()

# Get rooms adjacent to this one
func get_neighbors() -> PackedStringArray:
	var neighbors = []
	for e in exits_dict:
		var neighbor = e.get_other_end(room_id)
		if !(neighbor in neighbors):
			neighbors.append(neighbor)
	return neighbors

# Player is leaving, get info for switch
func player_exit(exit_id: String) -> void:
	var active_exit = exits_dict[exit_id]
	var target = active_exit.get_other_end(room_id)
	change_room.emit(target, exit_id)

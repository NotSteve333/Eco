extends Data
# Space which entities reside in, screens, levels
class_name RoomData

# Size/Shape of room
@export var camera_bounds: Vector4
# Exits to other rooms
@export var neighbors: PackedStringArray
@export var exits_dict: PackedVector2Array
# Watershed region this room resides in
@export var water_region: Region
# Light region this room resides in
@export var light_region: Region
# Temperaure region this room resides in
@export var temp_region: Region
# Polinator region this room resides in
@export var pol_region: Region

# plants in this room
@export var plants: Array[PlantData]
@export var surfaces: Array[Surface]
# Last time this room was updated
@export var last_update: float
# Historic events since last_update
var conditions_dict: Dictionary

signal room_data_ready(id: String)

func update() -> void:
	conditions_dict = combine_conditions()
	room_data_ready.emit(facade_id)

func get_region_conditions() -> Dictionary:
	return conditions_dict

func get_local_conditions(pos: Vector2) -> Vector3:
	for s in surfaces:
		if s.contains_point(pos):
			return s.get_all_conditions()
	return Vector3.ZERO
	
# Compile all events into a dictionary of vec4s
func combine_conditions() -> Dictionary:
	var water_events = water_region.get_events_since(last_update, facade_id)
	var light_events = light_region.get_events_since(last_update, facade_id)
	var temp_events = temp_region.get_events_since(last_update, facade_id)
	var pol_events = pol_region.get_events_since(last_update, facade_id)
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
func get_exit_location(exit_id: int) -> Vector2:
	return exits_dict[exit_id]

# Get rooms adjacent to this one
func get_neighbors() -> PackedStringArray:
	return neighbors

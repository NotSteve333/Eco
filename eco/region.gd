extends Resource
# Large area which manages long term environmental effects for several rooms.
class_name Region

# Name of region for identification purposes
var region_id: String
var events_type: PlantUtils.EventType

# Rooms within this region
# Format: rooms_info[room_id] = last_update
var rooms_info: Dictionary
# Most out of date room
var oldest_room: String
# Events log
# Format: (time, value)
var events: Array[Vector2]
var num_events: int

# Add an event to this region
func add_event(time: float, value: float) -> void:
	var new_event = Vector2(time, value)
	var index = events.bsearch(new_event)
	events.insert(index, new_event)
	num_events += 1

# Get rid of events more out of date than any room within this region
func cull_events_log() -> void:
	for room_id in  rooms_info:
		if rooms_info[room_id] <= rooms_info[oldest_room]:
			oldest_room = room_id
	var new_start = search_events(rooms_info[oldest_room])
	var cull_amt = 0
	for i in range(new_start):
		cull_amt += 1
	events = events.slice(new_start)
	num_events -= cull_amt

# Search the tuples based on only a float
func search_events(time: float) -> int:
	var t = Vector2(time, 0.0)
	return events.bsearch(t)

# Create new array of references to events tuples
func copy_events_portion(index: int) -> Array[Vector2]:
	var events_copy: Array[Vector2] = []
	for i in range(index, num_events):
		events_copy.append(events[i])
	return events_copy

# Get the events of a specified type since time for this region
func get_events_since(time: float, room: String) -> Array[Vector2]:
	var index = search_events(time)
	var copy = copy_events_portion(index)
	rooms_info[room] = time
	if room == oldest_room:
		cull_events_log()
		return events
	return copy

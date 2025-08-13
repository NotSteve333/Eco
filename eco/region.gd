extends Node
# Large area which manages long term environmental effects for several rooms.
class_name Region

# Name of region for identification purposes
@export var region_id: String

# Rooms within this region
var rooms: Array[Room]
# Events log
# Format: type_events[timestamp] = value
var water_events: Dictionary
var light_events: Dictionary
var temp_events: Dictionary

# Add an event to this region
func add_event(time: float, value: float, index: int) -> void:
	match index:
		0: water_events[time] = value
		1: light_events[time] = value
		2: temp_events[time] = value

# Get the events of a specified type for this region
func get_events(index: int) -> Dictionary:
	match index:
		0: return water_events
		1: return light_events
	return temp_events

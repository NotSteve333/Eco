extends Node
class_name PlantManager

# @onready var rng = RandomNumberGenerator.new()

const tick_interval: float = .2
const max_update_duration: float = 15000.0

# Plants to be updated stored here, packed together based on the room they're in
var plants_update_queue: Array[Plant] = []
var total_plants_in_queue: int
# Overhead for determining what room we're working on
var plants_in_room_queues: PackedInt64Array = []
var cur_room_amt: int = -1
# Last update for the current room
var rooms: Array[Room] = []
var cur_room: Room
var cur_update_time: float

func _ready() -> void:
	var cur_time = GlobalTime.get_total_seconds()

# Update as many plants as possible 
func _process(_delta: float) -> void:
	var start_time = Time.get_ticks_usec()
	var cur_global_time = GlobalTime.get_total_seconds()
	
	while total_plants_in_queue > 0:
		
		# Finish processing a room
		if cur_room_amt <= 0:
			cur_room_amt = plants_in_room_queues[-1]
			plants_in_room_queues.remove_at(-1)
			if cur_room:
				cur_room.set_last_update(cur_global_time)
			cur_room = rooms[-1]
			rooms.remove_at(-1)
			cur_update_time = cur_room.get_last_update()
			
		# Process a plant
		var plant = plants_update_queue.pop_back()
		var num_ticks = (cur_global_time - cur_update_time) / tick_interval
		plant.update(num_ticks)
		total_plants_in_queue -= 1
		cur_room_amt -= 1
		
		# Run out of time this frame
		if Time.get_ticks_usec() - start_time >= max_update_duration:
			return

func get_conditions(position: Vector2) -> PackedFloat64Array:
	return []

func _on_update_rooms(rooms: Array[Room], time: float) -> void:
	for r in rooms:
		var delta = r.get_last_update()
		var num_ticks = delta / tick_interval
		var new_plants = r.get_plants()
		plants_update_queue.append(new_plants)
		plants_in_room_queues.append(new_plants.size())
		rooms.append(r)
		

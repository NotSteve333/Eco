extends Node
class_name PlantManager

# @onready var rng = RandomNumberGenerator.new()

const tick_interval: float = .2
const max_update_duration: float = 15000.0

# Plants to be updated stored here, packed together based on the room they're in
var plants_update_queue: Array[Plant] = []
var total_plants_in_queue: int
# Overhead for determining what room we're working on
var plants_in_room_queues: Array[int] = []
var cur_room_amt: int = -1
# Info relating to current room
var rooms: Array[Room] = []
var cur_room: Room
var cur_region_cons: Dictionary
var cur_update_time: float
# Species info for room
var species_region_cons_cache: Dictionary

signal finish_room(room_id: String)

func _ready() -> void:
	var cur_time = GlobalTime.get_total_seconds()

# Update as many plants as possible 
func _process(_delta: float) -> void:
	var start_time = Time.get_ticks_usec()
	var cur_global_time = GlobalTime.get_total_seconds()
	
	while total_plants_in_queue > 0:
		
		# Finish processing a room
		if cur_room_amt <= 0:
			next_room()
			
		# Process a plant
		var plant = plants_update_queue.pop_back()
		var bake_encons: Dictionary
		var species = plant.get_species()
		if !species_region_cons_cache.has(species):
			species_region_cons_cache[species] = plant.process_region_conditions(cur_region_cons)
		bake_encons = species_region_cons_cache[plant]
		plant.update_plant(bake_encons, cur_room.get_local_conditions(plant.pos))
		total_plants_in_queue -= 1
		cur_room_amt -= 1
		
		# Run out of time this frame
		if Time.get_ticks_usec() - start_time >= max_update_duration:
			return

# Switch to a new room full of plants
func next_room() -> void:
	if cur_room:
		finish_room.emit(cur_room.room_id)
	cur_room_amt = plants_in_room_queues.pop_back()
	cur_room = rooms.pop_back()
	species_region_cons_cache.clear()
	cur_region_cons = cur_room.get_region_conditions()
	cur_update_time = cur_room.get_last_update()

# Set up room conditions for plants to use
func compile_conditions(region_cons: Dictionary, end_time: float) -> Dictionary:
	var timestamps = region_cons.keys()
	timestamps.sort()
	var num_ranges = timestamps.size()
	var num_ticks: int
	var compile_cons: Dictionary
	for i in range(num_ranges - 1):
		num_ticks = MathUtil.range_to_nums(timestamps[i], timestamps[i+1], tick_interval)
		compile_cons[num_ticks] = region_cons[timestamps[i]]
	num_ticks = MathUtil.range_to_nums(timestamps[num_ranges - 1], end_time, tick_interval)
	compile_cons[num_ticks] = region_cons[timestamps[num_ranges - 1]]
	return compile_cons
		

func get_region_conditions() -> Dictionary:
	return cur_room.get_region_conditions()

func get_local_conditions(position: Vector2) -> Vector3: 
	return Vector3.ZERO
	
# Recieve an entire room to process
func room_ready(r: Room) -> void:
	var new_plants = r.get_plants()
	plants_update_queue.append(new_plants)
	var num_plants = new_plants.size()
	plants_in_room_queues.append(num_plants)
	total_plants_in_queue += num_plants
	rooms.append(r)
		

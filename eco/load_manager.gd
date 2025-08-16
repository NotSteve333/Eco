extends Manager
# Managers the relationship between Data and Facades
class_name LoadManager

# Data instances which need their Facade loaded
var load_queue: Array[Data]
var load_queue_size: int = 0
# Scene's we've loaded in
var loaded_scenes: Dictionary
# Info for retaining work across frames
var load_stage: int = 0
var data_to_load: Data
var facade_path: String
var new_facade_packed_scene: PackedScene
var new_facade_scene: Facade
# How long we're willing to spend each frame loading in Facades
var frame_budget: float = 15000.0

# Load as many Facades in the queue as necessary until we run out of time.
# Splits the work up into multiple stages
func _process(_delta: float) -> void:
	var start_time = Time.get_ticks_usec()
	while load_queue_size > 0:
		if Time.get_ticks_usec() - start_time > frame_budget:
					return
		match load_stage:
			0:
				data_to_load = load_queue.pop_back()
				facade_path = data_to_load.get_facade()
				load_stage = 1
				continue
			1:
				new_facade_packed_scene = load(facade_path)
				load_stage = 2
				continue
			2: 
				new_facade_scene = new_facade_packed_scene.instantiate()
				new_facade_scene.set_data(data_to_load)
				loaded_scenes[new_facade_scene.get_id()] = new_facade_scene
				load_stage = 0
				continue

#
func unload_facade(facade_id: String) -> void:
	loaded_scenes[facade_id].write_to_data()
	loaded_scenes.erase(facade_id)

# Queue up more data for their facades to be loaded.
# Supports either Array[Data] or Data
func add_data_to_queue(new_data: Variant) -> void:
	if new_data is Array:
		load_queue.append_array(new_data)
		load_queue_size += new_data.size()
	else:
		load_queue.append(new_data)
		load_queue_size += 1
		

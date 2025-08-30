extends Manager
# Managers the relationship between Data and Facades
class_name LoadManager

# Data instances which need their Facade loaded
# Note: Consider implementing priority queue
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
	while load_queue_size > 0 or load_stage > 0:
		if Time.get_ticks_usec() - start_time > frame_budget:
					return
		match load_stage:
			0:
				data_to_load = load_queue.pop_back()
				load_queue_size -= 1
				facade_path = SaveManager.FacadesPaths[data_to_load.get_facade_id()]
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
				new_facade_scene.request_load.connect(add_data_to_queue)
				new_facade_scene.finish_loading()
				load_stage = 0
				# Clumsy, but should work?
				if new_facade_scene is PlantFacade:
					loaded_scenes[data_to_load.room_id].add_plant_child(new_facade_scene)
				continue

# Immediately load a Facade, skipping the queue.
# Note: Can cause stutters
# Note: Does not touch the load_queue, but does add to loaded_scenes
func quick_load(q_data: Data) -> Facade:

	# Take over in the event that the queue was already processing the same Data
	if load_stage > 0 and data_to_load == q_data:
		load_stage = 0

	var q_facade_id = q_data.get_facade_id()
	var q_facade_path = SaveManager.FacadesPaths[q_facade_id]
	var q_facade_packed_scene: PackedScene = load(q_facade_path)
	var q_facade_scene = q_facade_packed_scene.instantiate()
	q_facade_scene.set_data(q_data)
	loaded_scenes[q_facade_scene.get_id()] = q_facade_scene
	q_facade_scene.request_load.connect(add_data_to_queue)
	q_facade_scene.finish_loading()
	return q_facade_scene

# Jumps the queue to get a Facade loaded immediately
# Note: We might stutter if the asset wasn't ready ahead of time
func need_facade(data: Data, facade_id: String) -> Facade:
	# If loaded, return it
	if loaded_scenes.has(facade_id):
		return loaded_scenes[facade_id]

	# If in queue, remove it
	var data_to_quick_load: Data
	if data in load_queue:
		load_queue.erase(data)

	# Load the Facade
	return quick_load(data)

# Done with a Facade, remove it
func unload_facade(facade_id: String) -> void:
	if loaded_scenes.has(facade_id):
		loaded_scenes[facade_id].write_to_data()
		loaded_scenes[facade_id].queue_free()
		loaded_scenes.erase(facade_id)

# Queue up more data for their facades to be loaded.
# Note: Supports either Array[Data] or Data
func add_data_to_queue(new_data: Variant) -> void:
	if new_data is Array:
		load_queue.append_array(new_data)
		load_queue_size += new_data.size()
	else:
		load_queue.append(new_data)
		load_queue_size += 1

extends Facade
# Visual counterpart to RoomData
class_name RoomFacade

@export var camera_bounds: Vector4
var room_id: String

# Player is switching to target via exit_id
signal change_room(target: String, exit_id: String)

func get_room_dimensions() -> Vector2:
	return Vector2(camera_bounds.z - camera_bounds.x, camera_bounds.w - camera_bounds.y)

func set_data(data: Data) -> void:
	super(data)
	camera_bounds = data.camera_bounds
	room_id = data.facade_id

func finish_loading() -> void:
	super()
	request_load.emit(data.get_plants_data())

func add_plant_child(plant: PlantFacade) -> void:
	$Plants.add_child(plant)

func write_to_data() -> void:
	pass

# Player is leaving, get info for switch
func player_exit(exit_id: String) -> void:
	var active_exit = data.exits_dict[exit_id]
	var target = active_exit.get_other_end(room_id)
	change_room.emit(target, exit_id)

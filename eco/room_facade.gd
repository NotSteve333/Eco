extends Facade
# Visual counterpart to RoomData
class_name RoomFacade

var camera_bounds: Vector4
var exits_dict: Dictionary
var room_id: String
var has_exited: bool

# Player is switching to target via exit_id
signal change_room(target: String, exit_id: String)

func _ready() -> void:
	has_exited = false

func get_room_dimensions() -> Vector2:
	return Vector2(camera_bounds.z - camera_bounds.x, camera_bounds.w - camera_bounds.y)

func get_lims() -> Vector4:
	return camera_bounds

func set_data(new_data: Data) -> void:
	super(new_data)
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
	print(exit_id)
	if has_exited:
		return
	has_exited = true
	var active_exit = data.exits_dict[exit_id]
	var target = active_exit.get_other_end(room_id)
	change_room.emit(target, exit_id)

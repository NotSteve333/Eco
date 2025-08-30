extends Facade
# Visual counterpart to RoomData
class_name RoomFacade

@export var camera_bounds: Vector4
# Exits to other rooms
@export var exits_dict: PackedVector2Array
@export var neighbors: PackedStringArray
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
	facade_id = data.facade_id

func finish_loading() -> void:
	super()
	request_load.emit(data.get_plants_data())

func add_plant_child(plant: PlantFacade) -> void:
	$Plants.add_child(plant)

func write_to_data() -> void:
	pass

# Player is leaving, get info for switch
func player_exit(exit_id: String) -> void:
	if has_exited:
		return
	has_exited = true
	var active_exit = data.exits_dict[exit_id]
	var target = active_exit.get_other_end(data_id)
	change_room.emit(target, exit_id)

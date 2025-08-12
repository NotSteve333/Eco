extends Node2D
# Space which entities reside in, screens, levels
class_name Room

# Name of room for loading
@export var room_id: String
# Size/Shape of room
@export var camera_bounds: Vector4

# Last time this room was updated
var last_update: float
# Exits to other rooms
var exits_dict: Dictionary

# Player is switching to target via exit_id
signal change_room(target: String, exit_id: String)

# Returns plants in this room
func get_plants() -> Array[Node]:
	var plants_node = $Plants
	if plants_node:
		return plants_node.get_children()
	else:
		return []

# Set up exit dictionary. Could be hardcoded?
func _ready() -> void:
	var exits = $Exits.get_children()
	for e in exits:
		exits_dict[e.exit_id] = e
		e.receive_exit.connect(player_exit)

func get_last_update() -> float:
	return last_update
	
func set_last_update(time: float) -> void:
	last_update = time

# Gets where the player should enter this room from based on the exit they used
func get_exit_location(exit_id: String) -> Vector2:
	return exits_dict[exit_id].get_spawn_point()

# Get rooms adjacent to this one
func get_neighbors() -> PackedStringArray:
	var neighbors = []
	for e in exits_dict:
		var neighbor = e.get_other_end(room_id)
		if !(neighbor in neighbors):
			neighbors.append(neighbor)
	return neighbors

# Player is leaving, get info for switch
func player_exit(exit_id: String) -> void:
	var active_exit = exits_dict[exit_id]
	var target = active_exit.get_other_end(room_id)
	change_room.emit(target, exit_id)

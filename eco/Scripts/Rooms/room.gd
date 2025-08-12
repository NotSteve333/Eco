extends Node2D
class_name Room

@export var room_id: String
@export var camera_bounds: Vector4

var last_update: float
var exits_dict: Dictionary

signal change_room(target: String, exit_id: String)

func get_plants() -> Array[Node]:
	var plants_node = $Plants
	if plants_node:
		return plants_node.get_children()
	else:
		return []

func _ready() -> void:
	var exits = $Exits.get_children()
	for e in exits:
		exits_dict[e.exit_id] = e
		e.receive_exit.connect(player_exit)

func get_last_update() -> float:
	return last_update
	
func set_last_update(time: float) -> void:
	last_update = time

func get_exit_location(exit_id: String) -> Vector2:
	return exits_dict[exit_id].get_spawn_point()

func get_neighbors() -> PackedStringArray:
	var neighbors = []
	for e in exits_dict:
		var neighbor = e.get_other_end(room_id)
		if !(neighbor in neighbors):
			neighbors.append(neighbor)
	return neighbors

func player_exit(exit_id: String) -> void:
	var active_exit = exits_dict[exit_id]
	var target = active_exit.get_other_end(room_id)
	change_room.emit(target, exit_id)

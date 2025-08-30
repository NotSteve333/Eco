extends Node2D
# Connects two rooms
class_name RoomExit

@export var exit_id: String
@export var room_id_1: String
@export var room_id_2: String

# Player is leaving from this exit
signal player_exit(my_id: String)

# Signal linkage
func recieve_exit(body: Node2D) -> void:
	if body is Player:
		player_exit.emit(exit_id)

# Figures out which way the player was going
func get_other_end(entrance: String) -> String:
	if entrance == room_id_1:
		return room_id_2
	else:
		return room_id_1

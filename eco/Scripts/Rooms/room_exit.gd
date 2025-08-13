extends Node2D
# Connects two rooms
class_name RoomExit

# Name of exit for disambiguation
@export var exit_id: String
# Rooms which are connected by this exit
@export var connection: ExitConnection
# Where the player should spawn when they use this exit
@export var spawn_point: Vector2

# Player is leaving from this exit
signal player_exit(my_id: String)

# Signal linkage
func recieve_exit(body: Node2D) -> void:
	if body is Player:
		player_exit.emit(exit_id)
		
func get_spawn_point() -> Vector2:
	return spawn_point

# Figures out which way the player was going
func get_other_end(entrance: String) -> String:
	if entrance == connection.room_id_1:
		return connection.room_id_1
	else:
		return connection.room_id_2

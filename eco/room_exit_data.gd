extends Data
# 
class_name RoomExitData

# Rooms which are connected by this exit
@export var connection: ExitConnection
# Where the player should spawn when they use this exit
@export var spawn_point: Vector2

func get_spawn_point() -> Vector2:
	return spawn_point

# Figures out which way the player was going
func get_other_end(entrance: String) -> String:
	if entrance == connection.room_id_1:
		return connection.room_id_2
	else:
		return connection.room_id_1

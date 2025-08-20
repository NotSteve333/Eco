extends Facade
# Connects two rooms
class_name RoomExitFacade

@export var exit_id: String

# Player is leaving from this exit
signal player_exit(my_id: String)

# Signal linkage
func recieve_exit(body: Node2D) -> void:
	if body is Player:
		player_exit.emit(exit_id)

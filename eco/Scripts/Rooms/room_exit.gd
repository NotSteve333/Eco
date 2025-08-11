extends Node2D
class_name RoomExit

@export var exit_id: String
@export var connection: ExitConnection
@export var spawn_point: Vector2

signal player_exit(my_id: String)

func _ready() -> void:
	$Area2D.body_entered.connect(recieve_exit)

func recieve_exit(body: Node2D) -> void:
	if body is Player:
		player_exit.emit(exit_id)
		
func get_spawn_point() -> Vector2:
	return spawn_point

func get_other_end(entrance: String) -> String:
	if entrance == connection.room_id_1:
		return connection.room_id_1
	else:
		return connection.room_id_2

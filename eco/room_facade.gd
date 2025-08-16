extends Facade
# Visual counterpart to RoomData
class_name RoomFacade

var room_data: RoomData

func _init(data: RoomData):
	room_data = data

func write_to_data() -> void:
	pass

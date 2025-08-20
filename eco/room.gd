extends Node2D

@export var room_dimensions: Vector4

func get_room_dimensions() -> Vector2:
	return Vector2(room_dimensions.z - room_dimensions.x, room_dimensions.w - room_dimensions.y)

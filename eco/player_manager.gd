extends Manager
# Managers the player
class_name PlayerManager

@onready var player = %Player

func set_position(pos: Vector2) -> void:
	print(pos)
	if pos:
		player.position = pos
	else:
		player.position = Vector2.ZERO
	
func set_camera_limits(lims: Vector4) -> void:
	player.camera.limit_left = lims.x
	player.camera.limit_top = lims.y
	player.camera.limit_right = lims.z
	player.camera.limit_bottom = lims.w

func set_up_room(new_pos: Vector2, new_lims: Vector4) -> void:
	set_position(new_pos)
	set_camera_limits(new_lims)

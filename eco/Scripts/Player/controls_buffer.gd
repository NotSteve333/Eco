extends Node
class_name Controls

@export var buffer_size: int = 5
@export var buffer_actions: PackedStringArray = ["jump", "action_1", "action_2"]

@export var buffer: PackedStringArray
var direction: Vector2

func get_direction() -> Vector2:
	return direction

# Set up buffer
func _ready() -> void:
	for i in range(buffer_size):
		buffer.append("none")

func is_pressed(action: String) -> bool:
	return Input.is_action_pressed(action)

# Direction is often used by Player with only the x value, but why not track everything?
func _process(_delta: float) -> void:
	var dir_x = Input.get_axis("left", "right")
	var dir_y = Input.get_axis("up", "down")
	direction = Vector2(dir_x, dir_y)
	
	for action in buffer_actions:
		if Input.is_action_pressed(action) and !action in buffer:
			buffer[buffer_size - 1] = action
			advance_buffer()

func _physics_process(_delta: float) -> void:
	advance_buffer()
	
func advance_buffer() -> void:
	for i in range(buffer_size - 1):
		buffer[i] = buffer[i+1]
	buffer[buffer_size - 1] = "none"
	
func clear_buffer(action: String) -> void:
	for i in range(buffer_size):
		if buffer[i] == action:
			buffer[i] = "none"
	

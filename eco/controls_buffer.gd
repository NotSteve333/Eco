extends Node
class_name Controls

@export var buffer_size: int
@export var buffer_actions: PackedStringArray = ["jump", "action_1", "action_2"]

var buffer: PackedStringArray
var direction: Vector2

func _ready() -> void:
	for i in range(buffer_size):
		buffer.append("none")

func _process(_delta: float) -> void:
	var dir_x = Input.get_axis("left", "right")
	var dir_y = Input.get_axis("up", "down")
	direction = Vector2(dir_x, dir_y).normalized()
	
func _physics_process(_delta: float) -> void:
	advance_buffer()

func _input(event) -> void:
	for action in buffer_actions:
		if event.is_action_pressed(action) and !action in buffer:
			buffer[buffer_size - 1] = action
			advance_buffer()
	
func advance_buffer() -> void:
	for i in range(buffer_size - 1):
		buffer[i] = buffer[i+1]
	buffer[buffer_size - 1] = "none"
	
func clear_buffer(action: String) -> void:
	for i in range(buffer_size):
		if buffer[i] == action:
			buffer[i] = "none"
	

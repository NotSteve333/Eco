extends Parallax2D
# Parallax2D customized for easier setup
class_name CustomParallax

@export var background_dimensions: Vector2
@export var parallax_id: int
<<<<<<< HEAD
@export var far: bool
=======
>>>>>>> origin/dev

var camera_dimensions: Vector2
var foreground_span_ratios: Vector2
var level_dimensions: Vector2
var background_span_ratios: Vector2

func _ready() -> void:
	update_params()
	set_values()

# Update information on width/heights in scene
# Note: Does not change parallax visuals
func update_params() -> void:
	camera_dimensions = get_viewport().get_visible_rect().size
	level_dimensions = get_parent().get_parent().get_room_dimensions()
	foreground_span_ratios = Vector2(level_dimensions.x / camera_dimensions.x, level_dimensions.y / camera_dimensions.y)
	background_span_ratios = Vector2(background_dimensions.x / camera_dimensions.x, background_dimensions.y / camera_dimensions.y)

func compute_offset(ind: int) -> float:
	return (camera_dimensions[ind] - (scroll_scale[ind] * camera_dimensions[ind])) / 2.0

<<<<<<< HEAD

# Update parallax visuals based on current params
func set_values() -> void:
	scroll_scale = Vector2((background_span_ratios.x - 1) / (foreground_span_ratios.x - 1), (background_span_ratios.y - 1) / (foreground_span_ratios.y - 1))
	if far:
		scroll_scale = Vector2.ZERO
	var offset_y = compute_offset(1)
	var offset_x = compute_offset(0)
	scroll_offset = Vector2(offset_x, offset_y)
	print(parallax_id, " - Scroll: ", scroll_scale, ", Offset: ", scroll_offset)
=======
# Update parallax visuals based on current params
func set_values() -> void:
	scroll_scale = Vector2((background_span_ratios.x - 1) / (foreground_span_ratios.x - 1), (background_span_ratios.y - 1) / (foreground_span_ratios.y - 1))
	scroll_scale.y = 1.0
	var offset_y = 0.0
	var offset_x = compute_offset(0)
	scroll_offset = Vector2(offset_x, offset_y)
>>>>>>> origin/dev

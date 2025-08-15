extends CharacterBody2D

@export var speed = 100.0
var x_dir = 0.0
var y_dir = 0.0

func _process(delta: float) -> void:
	x_dir = Input.get_axis("left", "right")
	y_dir = Input.get_axis("up", "down")
	
func _physics_process(delta: float) -> void:
	velocity = velocity.move_toward(speed * Vector2(x_dir, y_dir), speed / 5.0)
	move_and_slide()

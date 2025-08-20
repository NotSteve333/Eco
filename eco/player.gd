extends CharacterBody2D
class_name Player

@onready var controls = $Controls
@onready var camera = %Camera2D

@export var speed = 300.0

var dir_x: float

func _physics_process(delta: float) -> void:
	# dir_x = controls.get_direction().x
	
	# velocity.x = move_toward(velocity.x, dir_x * speed, speed / 3.0)
	velocity = velocity.move_toward(controls.get_direction().normalized() * speed, speed / 3.0)
	
	#if !is_on_floor():
		#velocity += get_gravity()
		
	move_and_slide()

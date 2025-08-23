extends CharacterBody2D
class_name Player

@onready var controls = $Controls
@onready var camera = %Camera2D
@onready var animation = $AnimatedSprite2D
@onready var animation_control = $AnimationControl

@export var speed = 300.0
@export var jump_base = -700.0
@export var jump_range = -400.0

var dir_x: float

func _physics_process(delta: float) -> void:
	dir_x = controls.get_direction().x
	velocity.x = move_toward(velocity.x, dir_x * speed, speed / 3.0)

	if !is_on_floor():
		if velocity.y < 0:
			velocity += delta * get_gravity() * 1.2
		else:
			velocity += delta * get_gravity() * .85
	
	move_and_slide()

func execute_jump() -> void:
	velocity.y += jump_base + jump_range * ( animation_control.current_animation_position / animation_control.current_animation_length)
	
	animation_control.current_animation = "liftoff"

func _process(_delta: float) -> void:
	
	if is_on_floor() and !(animation_control.current_animation == "squat" or animation_control.current_animation == "liftoff" ) and "jump" in controls.buffer:
		animation_control.current_animation = "squat"
	
	if animation_control.current_animation == "squat" and !controls.is_pressed("jump"):
		execute_jump()
		
	if abs(dir_x) > 0.01:
		animation.play("walk")
		animation.flip_v = dir_x < 0
	else:
		animation.play("idle")

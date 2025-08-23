extends CharacterBody2D
class_name Player

@onready var controls = $Controls
@onready var camera = %Camera2D
@onready var animation = $AnimatedSprite2D

@export var speed = 300.0

var dir_x: float

func _physics_process(delta: float) -> void:
	dir_x = controls.get_direction().x
	velocity.x = move_toward(velocity.x, dir_x * speed, speed / 3.0)

	if !is_on_floor():
		velocity += get_gravity()

	move_and_slide()

func _process(_delta: float) -> void:
	if abs(dir_x) > 0.01:
		animation.play("walk")
		animation.flip_v = dir_x < 0
	else:
		animation.play("idle")

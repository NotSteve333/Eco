extends Node

# @onready var rng = RandomNumberGenerator.new()

const update_interval: float = .2

var plants_to_update: Array[Plant] = []

func _ready() -> void:
	var cur_time = GlobalTime.get_total_seconds()
	# rng.seed = int(10003 * (cur_time - int(cur_time)))

func _process(_delta: float) -> void:
	var cur_time = GlobalTime.get_total_seconds()
	if cur_time > last_update + update_interval:
		last_update = cur_time
		update_tick_plants()

func load_new_plants() -> void:
	pass

func get_conditions(position: Vector2) -> PackedFloat64Array:
	return []
	
func update_tick_plants() -> void:
	for p in plants_to_update:
		p.update()

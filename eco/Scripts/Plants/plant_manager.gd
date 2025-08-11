extends Node
class_name PlantManager

# @onready var rng = RandomNumberGenerator.new()

const tick_interval: float = .2

var plants_to_update: Array[Plant] = []

func _ready() -> void:
	var cur_time = GlobalTime.get_total_seconds()
	# rng.seed = int(10003 * (cur_time - int(cur_time)))


func get_conditions(position: Vector2) -> PackedFloat64Array:
	return []
	
func update_tick_plants(n: int) -> void:
	for p in plants_to_update:
		p.update()

func _on_update_rooms(rooms: Array[Room], time: float) -> void:
	for r in rooms:
		var delta = r.get_last_update()
		var num_ticks = delta / tick_interval
		plants_to_update.append(r.get_plants())
		

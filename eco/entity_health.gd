extends Node
class_name EntityHealth

@export var max_health: int

var cur_health: int
var is_alive: bool

signal took_damage(amt: int)
signal heal_damage(amt: int)
signal died()

func update_health(amt: int) -> void:
	cur_health = clamp(cur_health + amt, 0, max_health)
	if amt > 0:
		heal_damage.emit(max(amt, max_health - cur_health))
	else:
		took_damage.emit(min(amt, -1 * cur_health))
	if cur_health <= 0:
		is_alive = false
		died.emit()

extends Node

@export var time_scale: float = 1.0
const day_len_seconds: float = 86400.0
const night_start: float = .6 * day_len_seconds
const day_start: float = .25 * day_len_seconds

var total_time_seconds: float
var total_time_days: int
var day_time_seconds: float
var is_night: bool

signal night()
signal day()

func get_total_days() -> int:
	return total_time_days
	
func get_time_of_day() -> float:
	return day_time_seconds

func get_total_seconds() -> float:
	return total_time_seconds
	
func _process(delta: float) -> void:
	var scale_time = delta * time_scale
	total_time_seconds += scale_time
	day_time_seconds += scale_time
	if is_night and day_time_seconds >= day_start:
		day.emit()
		is_night = false
	if !is_night and day_time_seconds >= night_start:
		night.emit()
		is_night = true
	if day_time_seconds >= day_len_seconds:
		total_time_days += 1
		day_time_seconds = day_time_seconds - day_len_seconds
	 

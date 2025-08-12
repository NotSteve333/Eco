extends Node

# Rate at which time passes
@export var time_scale: float = 1.0

# Length of an in game day in seconds (86400.0 for 24 hours)
const day_len_seconds: float = 86400.0
# Time of day in seconds at which night starts
const night_start: float = .6 * day_len_seconds
# Time of day in seconds at which day starts
const day_start: float = .25 * day_len_seconds

# Time (in game) in seconds since the save has started
var total_time_seconds: float
# Time (in game) in days since the save has started
var total_time_days: int
# Time in seconds since the in game day has started
var day_time_seconds: float
var is_night: bool

# Night has started
signal night()
# Day has started
signal day()

# Increase total time and derivatives. Set day/night.
# Called from _process, but exposed for other uses (waiting, cutscenes)
func pass_time(length: float) -> void:
	var scale_time = length * time_scale
	total_time_seconds += scale_time
	day_time_seconds += scale_time
	
	# Set night/day
	if is_night and day_time_seconds >= day_start:
		day.emit()
		is_night = false
	elif !is_night and day_time_seconds >= night_start:
		night.emit()
		is_night = true
	if day_time_seconds >= day_len_seconds:
		total_time_days += 1
		day_time_seconds = day_time_seconds - day_len_seconds

# Update time. Note that time does not pass if this node's process is stopped
func _process(delta: float) -> void:
	pass_time(delta)

func get_total_days() -> int:
	return total_time_days
	
func get_time_of_day() -> float:
	return day_time_seconds

func get_total_seconds() -> float:
	return total_time_seconds
	

	 

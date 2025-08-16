extends Node2D
# Part of Data/Facade dichotomy. 
# Data is simulated upon, and informs the Facade how to display
class_name Facade

var data: Data

func set_data(init_data: Data) -> void:
	data = init_data

func get_id() -> String:
	return ""

func write_to_data() -> void:
	pass

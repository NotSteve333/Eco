extends Node2D
# Part of Data/Facade dichotomy. 
# Data is simulated upon, and informs the Facade how to display
class_name Facade

var data: Data

signal request_load(datas: Variant)

func set_data(init_data: Data) -> void:
	data = init_data

# LoadManager has finished setup
func finish_loading() -> void:
	data.set_facade(self)

func unload() -> void:
	data.set_facade(null)

func get_id() -> String:
	return data.facade_id
	
func get_data() -> Data:
	return data

func write_to_data() -> void:
	pass

extends Node2D
# Part of Data/Facade dichotomy. 
# Data is simulated upon, and informs the Facade how to display
class_name Facade

@export var facade_id: String
@export var data_id: String
@export var data: Data

signal request_load(datas: Variant)

func set_data(init_data: Data) -> void:
	data = init_data
	data_id = data.data_id

# LoadManager has finished setup
func finish_loading() -> void:
	data.set_facade(self)

func unload() -> void:
	data.set_facade(null)

func get_id() -> String:
	return data.facade_id
	
func get_data() -> Data:
	return data

# Inheritors need to overwrite
func write_to_data() -> void:
	print("Saving")
	if !data:
		data = SaveManager.create_data(self, data_id)

extends Resource
# Part of Data/Facade dichotomy. 
# Data is simulated upon, and informs the Facade how to display
class_name Data

@export var facade_id: String
var facade: Facade

# Inheriting classes need to override
func get_data_to_load() -> void:
	pass

func set_facade(init_facade: Facade) -> void:
	facade = init_facade
	
func get_facade() -> Facade:
	return facade

func get_facade_id() -> String:
	return facade_id

func save() -> void:
	pass

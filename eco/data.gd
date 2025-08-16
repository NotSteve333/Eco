extends Resource
# Part of Data/Facade dichotomy. 
# Data is simulated upon, and informs the Facade how to display
class_name Data

var facade_id: String

# Inheriting classes need to override
func get_data_to_load() -> void:
	pass
	
func get_facade_id() -> String:
	return facade_id

func save() -> void:
	pass

@tool
extends VBoxContainer
# Used for plugin
class_name DataSaverDock

signal receive_scene(save: bool)
signal talk_to_file(save: bool)

func save_button_pressed() -> void:
	receive_scene.emit(true)

func load_button_pressed() -> void:
	receive_scene.emit(false)

func save_to_file() -> void:
	talk_to_file.emit(true)
	
func load_from_file() -> void:
	talk_to_file.emit(false)

@tool
extends EditorPlugin

# A class member to hold the dock during the plugin life cycle.
var dock: DataSaverDock
var active_scene: Node
var facades_to_save: Array[Facade]

func _enter_tree():
	# Load the dock scene, instantiate it, and connect signals
	dock = preload("res://Scenes/data_saver_dock.tscn").instantiate()
	dock.receive_scene.connect(save_or_load_scene)
	dock.talk_to_file.connect(save_or_load_to_file)
	
	# Add the loaded scene to the docks.
	add_control_to_dock(DOCK_SLOT_LEFT_UL, dock)
	save_or_load_to_file(false)
	

func save_or_load_to_file(save: bool) -> void:
	if save:
		SaveManager.write_to_json()
	else:
		SaveManager.load_from_json()

func save_or_load_scene(save: bool) -> void:
	active_scene = get_editor_interface().get_edited_scene_root()
	if save:
		save_scene()
	else:
		load_scene()

func save_scene() -> void:
	var plants: Array[Node]
	var hinges = active_scene.get_children()
	for n in hinges:
		if n.name == "Plants":
			plants = n.get_children()
			break
	for p in plants:
		SaveManager.save_plant(p, active_scene.facade_id)
	SaveManager.save_room(active_scene)

func load_scene() -> void:
	pass

func _exit_tree():
	# Clean-up of the plugin goes here.
	# Remove the dock.
	remove_control_from_docks(dock)
	save_or_load_to_file(true)
	# Erase the control from the memory.
	dock.free()

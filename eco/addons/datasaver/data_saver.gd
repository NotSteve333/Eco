@tool
extends EditorPlugin

# A class member to hold the dock during the plugin life cycle.
var dock: DataSaverDock
var active_scene: Node
var is_scene_loaded: bool
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
	var check_for_change = get_editor_interface().get_edited_scene_root()
	if check_for_change != active_scene:
		active_scene = check_for_change
		is_scene_loaded = false
	if save and is_scene_loaded:
		save_scene()
		is_scene_loaded = false
	elif !save and !is_scene_loaded:
		load_scene()
		is_scene_loaded = true

func save_scene() -> void:
	var plants: Array[Node]
	var plant_hinge: Node
	var hinges = active_scene.get_children()
	for n in hinges:
		if n.name == "Plants":
			plant_hinge = n
			plants = n.get_children()
			break
	var new_data: Array[PlantData]
	for p in plants:
		new_data.append(SaveManager.save_plant(p, active_scene.facade_id))
		plant_hinge.remove_child(p)
	active_scene.plants = new_data
	SaveManager.save_room(active_scene)

func load_scene() -> void:
	var plants_to_load = active_scene.plants
	var plant_hinge: Node = active_scene.get_node("Plants")
	for p in plants_to_load:
		var new_plant = SaveManager.load_plant(p)
		add_child_to_selected(new_plant, plant_hinge)
		print(new_plant.position)
		
func add_child_to_selected(node: Node, parent: Node):
	var undo_redo = get_undo_redo()
	undo_redo.create_action("Add Child")
	undo_redo.add_do_method(parent, "add_child", node)
	undo_redo.add_do_method(node, "set_owner", active_scene)
	undo_redo.add_undo_method(parent, "remove_child", node)
	undo_redo.commit_action()
	
func _exit_tree():
	# Clean-up of the plugin goes here.
	# Remove the dock.
	remove_control_from_docks(dock)
	save_or_load_to_file(true)
	# Erase the control from the memory.
	dock.free()

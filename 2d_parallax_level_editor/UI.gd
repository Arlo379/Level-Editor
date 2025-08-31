@tool
extends Node
class_name Parralax_tool 

@export var container_for_Layers:Node = null 

@export var scroll_multiplier: float = 1: set = _calculate_scroll

var editor_pos = Vector2(0,0)

var Parallax: bool = true

var P_array = []

var Z_index: int

var New_layer

var Index

var Parent_array

var selection

var scrollX

var scrollY

var view

var scroll 

func _ready() -> void:
	if Engine.is_editor_hint() == true:
		_default_to_parent(container_for_Layers)


func _process(delta: float) -> void:
	if Engine.is_editor_hint():
		_Action_Manager()
		_Parallax_in_editor()



func _Action_Manager():
		if Input.is_action_just_pressed("Center"):
			_centre()
		if Input.is_action_just_pressed("Toggle_Parallax"):
			_Disable_Parallax()
		if Input.is_action_just_pressed("Up_In_Layer"):
			_up_in_layer()
		if Input.is_action_just_pressed("Down_In_Layer"):
			_down_in_layer()
		if Input.is_action_just_pressed("New_close_Layer"):
			_new_layer(1,sort_descending)
			_sort_layers()
		if Input.is_action_just_pressed("New_Far_Layer"):
			_new_layer(-1,sort_ascending)
			_sort_layers()


func _Parallax_in_editor():
	view = EditorInterface.get_editor_viewport_2d()
	if Parallax == true:
		for node in container_for_Layers.get_children():
			if node is Parallax2D:
				scrollX = node.scroll_scale.x
				scrollY = node.scroll_scale.y
				node.follow_viewport = true
				node.ignore_camera_scroll = false
				node.scroll_offset = node.position + -(editor_pos - view.global_canvas_transform.origin) * scrollX / view.global_canvas_transform.get_scale()
	editor_pos = view.global_canvas_transform.origin


func _Disable_Parallax():
	if Parallax == false:
		Parallax = true
	else:
		Parallax = false


func _centre():
	for node in container_for_Layers.get_children():
		if node is Parallax2D:
			node.scroll_offset = Vector2(0,0)
			node.position = Vector2(0,0)
			#for nod in node.get_children():
				#nod.position = Vector2(0,0)


func _up_in_layer(): 
	_move_in_layers()
	for node in selection.get_selected_nodes():
		if node.get_parent() is Parallax2D:
			Index = Parent_array.find(node.get_parent())

			if not Index == 0:
				node.reparent(Parent_array[Index + -1])
				EditorInterface.get_selection().add_node(node)


func _down_in_layer():
	_move_in_layers()
	for node in selection.get_selected_nodes():
		if node.get_parent() is Parallax2D:
			Index = Parent_array.find(node.get_parent())

			if Index < Parent_array.size() - 1:
				node.reparent(Parent_array[Index +1])
				EditorInterface.get_selection().add_node(node)


func _move_in_layers():
	P_array = []
	for node in container_for_Layers.get_children():
		if node is Parallax2D:
			P_array.append({"name": node, "z_index": node.z_index})
	P_array.sort_custom(_High_to_low_sort)

	Parent_array = []
	for i in P_array:
		Parent_array.append(i["name"])
	selection = EditorInterface.get_selection()


func _new_layer(z_indexMod, sort):
	P_array = []
	if _check_empty() == true:
		_create_node(0, Vector2(1,1))
		return
	for node in container_for_Layers.get_children():
		if node is Parallax2D:
			P_array.append(node.z_index)
	P_array.sort_custom(sort)

	Z_index = P_array[0]
	scroll = pow(scroll_multiplier, Z_index + z_indexMod)
	_create_node(Z_index + z_indexMod, Vector2(scroll,scroll))


func _sort_layers():
	P_array = []
	for node in container_for_Layers.get_children():
		if node is Parallax2D:
			P_array.append({"name": node, "z_index": node.z_index})
	P_array.sort_custom(_High_to_low_sort)

	Parent_array = []
	for i in P_array:
		Parent_array.append(i["name"])
	for i in Parent_array.size():
		container_for_Layers.move_child(Parent_array[i],i)


func _calculate_scroll(_new):
	scroll_multiplier = _new
	P_array = []
	for node in container_for_Layers.get_children():
		if node is Parallax2D:
			P_array.append({"name": node, "z_index": node.z_index})
	P_array.sort_custom(_High_to_low_sort)

	Parent_array = []
	for i in P_array:
		Parent_array.append(i["name"])
	for i in Parent_array.size():
		scroll = pow(scroll_multiplier, P_array[i]["z_index"])
		Parent_array[i].scroll_scale = Vector2(scroll,scroll)


func _check_empty():
	for i in container_for_Layers.get_children():
		if i is Parallax2D:
			return false
	return true


func _create_node(Z_index, scroll_scale):
	New_layer = Parallax2D.new()
	New_layer.name = "Parallax2D: z_index:" + str(Z_index)
	New_layer.z_index = Z_index
	New_layer.scroll_scale = scroll_scale
	container_for_Layers.add_child(New_layer)
	New_layer.owner = get_tree().edited_scene_root


func _default_to_parent(_value):
	if container_for_Layers == null:
		_value = get_parent()


func _High_to_low_sort(a, b):
	if a["z_index"] > b["z_index"]:
		return true
	return false


func sort_descending(a,b):
	if a > b:
		return true
	return false


func sort_ascending(a,b):
	if a > b:
		return false
	return true

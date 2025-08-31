@tool
extends VBoxContainer
class_name level_UI

func _enter_tree():
	_add_action("Center", KEY_C)
	_add_action("Toggle_Parallax", KEY_T)
	_add_action("Down_In_Layer", KEY_D)
	_add_action("Up_In_Layer", KEY_U)
	_add_action("New_close_Layer", KEY_L)
	_add_action("New_Far_Layer", KEY_N)
	_add_action("Toggle_camera", KEY_R)
	ProjectSettings.save()
	InputMap.load_from_project_settings()



func _add_action(name, key, shift = false, Alt = true):
	if not InputMap.has_action("name"):
		InputMap.add_action("name")
	var event_key = InputEventKey.new()
	event_key.physical_keycode = key
	event_key.shift_pressed = shift
	event_key.alt_pressed = Alt
	
	var input = {
	"deadzone": 0.5,
	"events": [event_key]
	}
	ProjectSettings.set_setting("input/" + str(name),input)








func _on_center_button_pressed() -> void:
	_kinda_signal("Center")



func _on_up_in_layer_pressed() -> void:
	_kinda_signal("Up_In_Layer")



func _on_down_in_layer_pressed() -> void:
	_kinda_signal("Down_In_Layer")



func _on_disable_parallax_button_pressed() -> void:
	_kinda_signal("Toggle_Parallax")



func _on_new_close_pressed() -> void:
	_kinda_signal("New_close_Layer")


func _on_new_far_pressed() -> void:
	_kinda_signal("New_Far_Layer")


func _on_toggle_camera_pressed() -> void:
	_kinda_signal("Toggle_camera")

func _kinda_signal(name_of_action):
	Input.action_press(name_of_action)
	Input.action_release(name_of_action)

@tool
extends EditorPlugin
var Level_UI
const LEVEL_EDITOR_UI = preload("res://addons/2d_parallax_level_editor/scenes/level_editor_UI.tscn")
func _enter_tree() -> void:
	Level_UI = LEVEL_EDITOR_UI.instantiate()
	
	add_control_to_dock(EditorPlugin.DOCK_SLOT_LEFT_BL,Level_UI)
	pass


func _exit_tree() -> void:
	remove_control_from_docks(Level_UI)
	
	Level_UI.queue_free()
	
	InputMap.erase_action("Center")
	pass
	

@tool
extends Node2D
class_name Draw_tool

@export var camera: Camera2D = null

@export var Character: Sprite2D = null

@export_color_no_alpha var color_of_rect = Color(0,0,0)

@export var width: float = 10

var size = Vector2(1160,648)

var view 

var rectangle

var camera_on = true

var should_draw = true

func _ready() -> void:
	if Engine.is_editor_hint() == true:
		_default_to_camera()
		_default_to_Character()
		camera.editor_draw_screen = false
	else:
		Character.hide()


func  _default_to_Character():
	for i in get_parent().get_children():
		if i is Sprite2D:
			Character = i
			return

func _default_to_camera():
	for i in get_parent().get_children():
		if i is Camera2D:
			camera = i
			return


func _draw() -> void:
	if should_draw:
		if Engine.is_editor_hint():
			draw_rect(rectangle, color_of_rect, false, width)

func _process(delta: float) -> void:
	if Engine.is_editor_hint() == true:
		if not camera == null:
			if Input.is_action_just_pressed("Toggle_camera"):
				if camera_on == true:
					camera_on = false
				else:
					camera_on = true
				Character.visible = camera_on
				should_draw = camera_on
			#camera.position = (-view.global_canvas_transform.origin + Vector2(view.size)/2) / view.global_canvas_transform.get_scale()
			size = Vector2(1160,648) / camera.zoom
			
			view = EditorInterface.get_editor_viewport_2d()
			
			rectangle = Rect2((-view.global_canvas_transform.origin + Vector2(view.size)/2) / view.global_canvas_transform.get_scale() - size/2 ,size)
			queue_redraw()
			if not Character == null:
				Character.position = (-view.global_canvas_transform.origin + Vector2(view.size)/2) / view.global_canvas_transform.get_scale()

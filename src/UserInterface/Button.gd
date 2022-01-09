tool
extends Control

export(int) var width = 50 setget set_width
export(int) var height = 20 setget set_height
export(int) var variant = 0 setget set_variant
export(String) var text = "" setget set_text
export(Color) var color = Color.black setget set_color

var padding = 10
var patch_width = 48
var patch_height = 48
var pressed = false
var ready = false

signal pressed()

func _ready():
	ready = true

	_apply_style()
	
func _apply_style():
	if !ready:
		return

	rect_size = Vector2(width, height)

	$NinePatchRect.margin_right = width
	$NinePatchRect.margin_bottom = height
	
	$Label.margin_left = padding / 2
	$Label.margin_right = width - padding / 2
	$Label.margin_bottom = height - padding / 2
	
	if pressed:
		$Label.margin_top = 2
		$NinePatchRect.region_rect.position = Vector2(patch_width, variant * patch_height)
	else:
		$Label.margin_top = 1
		$NinePatchRect.region_rect.position = Vector2(0, variant * patch_height)

	$Label.add_color_override("font_color", color)
	$Label.text = text
	
func _input(_event):
	if !is_visible_in_tree() or Globals.dialogicActive:
		return

	if Input.is_action_just_pressed("ui_click_left"):
		var rect = Rect2(rect_global_position, Vector2(width, height))
				
		if rect.has_point(get_global_mouse_position()):
			pressed = true

		_apply_style()

	if Input.is_action_just_released("ui_click_left"):
		if pressed:
			emit_signal("pressed")

		pressed = false

		_apply_style()

func set_width(value):
	width = value
	
	_apply_style()
	
func set_height(value):
	height = value
	
	_apply_style()
	
func set_variant(value):
	variant = clamp(value, 0, 10)
	
	_apply_style()
	
func set_text(value):
	text = value
	
	_apply_style()
	
func set_color(value):
	color = value
	
	_apply_style()

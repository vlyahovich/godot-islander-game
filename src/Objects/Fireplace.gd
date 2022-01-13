extends StaticBody2D

var last_area = null

func _ready():
	$CanvasLayer/PopupWindow.visible = false
	$CanvasLayer/Overlay.visible = false

func _on_Interactable_interacted(area):
	last_area = area

	_open_popup()

func _open_popup():
	Globals.dialogicActive = true

	var origin = get_global_transform_with_canvas().origin
	var viewport_size = $CanvasLayer/Overlay.rect_size
	var popup_size = $CanvasLayer/PopupWindow.rect_size
	var pos_x = clamp(origin.x + 4, 0, viewport_size.x)
	var pos_y = clamp(origin.y - popup_size.y / 2, 0, viewport_size.y)

	$CanvasLayer/PopupWindow.rect_position = Vector2(pos_x, pos_y)
	$CanvasLayer/PopupWindow.visible = true
	$CanvasLayer/Overlay.visible = true
	$CanvasLayer/Tween.interpolate_property(
		$CanvasLayer/PopupWindow,
		"modulate",
		Color.transparent,
		Color.white,
		0.25,
		Tween.TRANS_LINEAR,
		Tween.EASE_IN
	)
	$CanvasLayer/Tween.interpolate_property(
		$CanvasLayer/PopupWindow,
		"rect_scale",
		Vector2.ZERO,
		Vector2(1, 1),
		0.25,
		Tween.TRANS_LINEAR,
		Tween.EASE_IN
	)
	$CanvasLayer/Tween.interpolate_property(
		$CanvasLayer/Overlay,
		"modulate",
		Color.transparent,
		Color.white,
		0.25,
		Tween.TRANS_LINEAR,
		Tween.EASE_IN
	)
	$CanvasLayer/Tween.start()

func _close_popup():
	Globals.dialogicActive = false
	
	$CanvasLayer/Tween.interpolate_property(
		$CanvasLayer/PopupWindow,
		"modulate",
		Color.white,
		Color.transparent,
		0.15,
		Tween.TRANS_LINEAR,
		Tween.EASE_IN
	)
	$CanvasLayer/Tween.interpolate_property(
		$CanvasLayer/PopupWindow,
		"rect_scale",
		Vector2(1, 1),
		Vector2.ZERO,
		0.15,
		Tween.TRANS_LINEAR,
		Tween.EASE_IN
	)
	$CanvasLayer/Tween.interpolate_property(
		$CanvasLayer/Overlay,
		"modulate",
		Color.white,
		Color.transparent,
		0.25,
		Tween.TRANS_LINEAR,
		Tween.EASE_IN
	)
	$CanvasLayer/Tween.start()

	yield($CanvasLayer/Tween, "tween_completed")

	$CanvasLayer/PopupWindow.visible = false
	$CanvasLayer/Overlay.visible = false

func _on_RestButton_pressed():
	$RestoreSound.play()

	last_area.notify_rested()

	_close_popup()

func _on_CloseButton_pressed():
	_close_popup()

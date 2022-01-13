extends Node

var last_area = null
var selection = 0

signal reset_pressed(area)
signal upgrade_pressed(area)
signal closed

func _ready():
	$CanvasLayer/PopupWindow.visible = false
	$CanvasLayer/Overlay.visible = false
	$CanvasLayer/PopupWindow/Crosshair.visible = false

func open_popup(origin: Vector2):
	last_area = null
	selection = 0

	Globals.dialogicActive = true

	var viewport_size = $CanvasLayer/Overlay.rect_size
	var popup_size = $CanvasLayer/PopupWindow.rect_size
	var pos_x = clamp(origin.x + 4, 0, viewport_size.x)
	var pos_y = clamp(origin.y - popup_size.y / 2, 0, viewport_size.y)

	$CanvasLayer/PopupWindow.rect_position = Vector2(pos_x, pos_y)
	$CanvasLayer/PopupWindow.visible = true
	$CanvasLayer/Overlay.visible = true
	$CanvasLayer/PopupWindow/Crosshair.visible = false
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

func open_popup_with_area(origin: Vector2, area: Area2D):
	last_area = area

	open_popup(origin)

func close_popup():
	last_area = null

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
	$CanvasLayer/PopupWindow/Crosshair/AnimationPlayer.stop()

	emit_signal("closed")

func _on_RestButton_pressed():
	emit_signal("reset_pressed", last_area)

func _on_UpgradeButton_pressed():
	emit_signal("upgrade_pressed", last_area)

func _on_CloseButton_pressed():
	close_popup()

func _on_Slot1_pressed():
	var pos = $CanvasLayer/PopupWindow/Slot1.rect_position

	$CanvasLayer/PopupWindow/Crosshair.visible = true
	$CanvasLayer/PopupWindow/Crosshair.position = Vector2(3, pos.y)
	$CanvasLayer/PopupWindow/Crosshair/AnimationPlayer.play("animate")

	selection = 1

func _on_Slot2_pressed():
	var pos = $CanvasLayer/PopupWindow/Slot2.rect_position

	$CanvasLayer/PopupWindow/Crosshair.visible = true
	$CanvasLayer/PopupWindow/Crosshair.position = Vector2(3, pos.y)
	$CanvasLayer/PopupWindow/Crosshair/AnimationPlayer.play("animate")

	selection = 2

func _on_Slot3_pressed():
	var pos = $CanvasLayer/PopupWindow/Slot3.rect_position

	$CanvasLayer/PopupWindow/Crosshair.visible = true
	$CanvasLayer/PopupWindow/Crosshair.position = Vector2(3, pos.y)
	$CanvasLayer/PopupWindow/Crosshair/AnimationPlayer.play("animate")

	selection = 3

func _on_Slot1_button_down():
	$CanvasLayer/PopupWindow/Slot1.rect_scale = Vector2(0.98, 0.98)

func _on_Slot1_button_up():
	$CanvasLayer/PopupWindow/Slot1.rect_scale = Vector2(1, 1)

func _on_Slot2_button_down():
	$CanvasLayer/PopupWindow/Slot2.rect_scale = Vector2(0.98, 0.98)

func _on_Slot2_button_up():
	$CanvasLayer/PopupWindow/Slot2.rect_scale = Vector2(1, 1)

func _on_Slot3_button_down():
	$CanvasLayer/PopupWindow/Slot3.rect_scale = Vector2(0.98, 0.98)

func _on_Slot3_button_up():
	$CanvasLayer/PopupWindow/Slot3.rect_scale = Vector2(1, 1)

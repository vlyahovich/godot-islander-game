extends Node

var player_area = null
var selection = 0

signal reset_pressed(area)
signal closed

func _ready():
	$CanvasLayer/PopupWindow.visible = false
	$CanvasLayer/Overlay.visible = false
	$CanvasLayer/PopupWindow/Crosshair.visible = false

func open_popup(origin: Vector2):
	selection = 0

	_update_weapon(player_area.player.weapon)
	_update_axe(player_area.player.axe)
	_update_pickaxe(player_area.player.pickaxe)

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
	$OpenSound.play()

func open_popup_with_area(origin: Vector2, area: PlayerInteractionZone):
	player_area = area

	open_popup(origin)

func close_popup():
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

func _update_weapon(weapon):
	_update_slot($CanvasLayer/PopupWindow/Slot1, weapon)

func _update_axe(axe):
	_update_slot($CanvasLayer/PopupWindow/Slot2, axe)

func _update_pickaxe(pickaxe):
	_update_slot($CanvasLayer/PopupWindow/Slot3, pickaxe)
	
func _update_all():
	_update_weapon(player_area.player.weapon)
	_update_axe(player_area.player.axe)
	_update_pickaxe(player_area.player.pickaxe)
	
func _update_slot(slot: Control, obj):
	if obj.level == obj.max_level:
		slot.get_node("Slot/Label").text = "MAX"
		slot.get_node("Slot/Sprite").frame = obj.levelSprites[obj.level - 1]
		
		slot.get_node("Res1").frame = 0
		slot.get_node("Res2").frame = 45

		slot.get_node("Res1Count").text = "N/A"
		slot.get_node("Res2Count").text = "N/A"

		return

	var costs = obj.upgradeCosts[obj.level - 1]

	slot.get_node("Slot/Label").text = "Lv." + str(obj.level)
	slot.get_node("Slot/Sprite").frame = obj.levelSprites[obj.level - 1]
	
	var res1 = costs[0]
	var res2 = costs[1]

	slot.get_node("Res1").frame = res1[0].sprite
	slot.get_node("Res2").frame = res2[0].sprite

	slot.get_node("Res1Count").text = str(res1[1])
	slot.get_node("Res2Count").text = str(res2[1])

	if PlayerInventory.has_enough_resources([res1[0]], [res1[1]]):
		slot.get_node("Res1Count").add_color_override("font_color", Color(1, 1, 1))
	else:
		slot.get_node("Res1Count").add_color_override("font_color", Color(0.5, 0.5, 0.5))

	if PlayerInventory.has_enough_resources([res2[0]], [res2[1]]):
		slot.get_node("Res2Count").add_color_override("font_color", Color(1, 1, 1))
	else:
		slot.get_node("Res2Count").add_color_override("font_color", Color(0.5, 0.5, 0.5))

func _upgrade_slot(slot, obj):
	if obj.level == obj.max_level:
		$ErrorSound.play()

		return

	var costs = obj.upgradeCosts[obj.level - 1]
	var res1 = costs[0]
	var res2 = costs[1]

	if PlayerInventory.use_resources([res1[0], res2[0]], [res1[1], res2[1]]):
		obj.level += 1
		
		var pos = slot.rect_position
		var offset_x = 13
		var offset_y = 11

		$CanvasLayer/PopupWindow/Particles2D.restart()
		$CanvasLayer/PopupWindow/Particles2D.position = Vector2(offset_x, pos.y + offset_y)
		$CanvasLayer/PopupWindow/Particles2D.emitting = true

		$UpgradeSound.play()
	else:
		$ErrorSound.play()

	_update_all()

func _on_RestButton_pressed():
	emit_signal("reset_pressed", player_area)

func _on_UpgradeButton_pressed():
	var weapon = player_area.player.weapon
	var axe = player_area.player.axe
	var pickaxe = player_area.player.pickaxe

	if selection == 0:
		$ErrorSound.play()

	match selection:
		1:
			_upgrade_slot($CanvasLayer/PopupWindow/Slot1, weapon)
		2:
			_upgrade_slot($CanvasLayer/PopupWindow/Slot2, axe)
		3:
			_upgrade_slot($CanvasLayer/PopupWindow/Slot3, pickaxe)

func _on_CloseButton_pressed():
	close_popup()

	$CloseSound.play()

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

extends StaticBody2D

func _on_Interactable_interacted(area):
	$CraftingMenu.open_popup_with_area(
		get_global_transform_with_canvas().origin,
		area
	)

func _on_CraftingMenu_reset_pressed(area):
	$RestoreSound.play()

	if area:
		area.notify_rested()

	$CraftingMenu.close_popup()

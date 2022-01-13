extends StaticBody2D

func _on_Interactable_interacted(area: PlayerInteractionZone):
	$CraftingMenu.open_popup_with_area(
		get_global_transform_with_canvas().origin,
		area
	)

func _on_CraftingMenu_reset_pressed(area: PlayerInteractionZone):
	$RestoreSound.play()

	if area:
		area.notify_rested()

	$CraftingMenu.close_popup()

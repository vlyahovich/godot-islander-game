extends StaticBody2D

func _on_Interactable_interacted(area):
	$RestoreSound.play()
	
	area.notify_rested()

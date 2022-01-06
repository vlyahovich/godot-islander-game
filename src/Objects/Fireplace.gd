extends StaticBody2D

func _on_Interactable_interacted(area):
	area.notify_rested()

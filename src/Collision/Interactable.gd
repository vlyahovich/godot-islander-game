extends Node2D

var crosshair_active = false
var is_player_inside = false

signal interacted(area)
signal interacted_coursor(area)

func _on_Area2D_area_entered(area):
	var groups = area.get_groups()

	if "Crosshair" in groups:
		if is_player_inside:
			emit_signal("interacted_coursor", area)

		crosshair_active = true
	
	if crosshair_active and "Player" in groups:
		emit_signal("interacted", area)
		
		is_player_inside = true
		crosshair_active = false


func _on_Area2D_area_exited(area):
	var groups = area.get_groups()
	
	if "Player" in groups:
		is_player_inside = false

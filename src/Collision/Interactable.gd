extends Node2D

var crosshair_active = false
var is_player_inside = false
var active = true setget set_active

signal interacted(area)
signal interacted_coursor(area)

func set_active(value):
	active = value
	
	if active:
		$Area2D/CollisionShape2D.set_deferred("disabled", false)
	else:
		$Area2D/CollisionShape2D.set_deferred("disabled", true)

func _on_Area2D_area_entered(area):
	var groups = area.get_groups()

	if "Crosshair" in groups:
		if is_player_inside:
			emit_signal("interacted_coursor", area)

		crosshair_active = true
	
	if "Player" in groups:
		if crosshair_active:
			emit_signal("interacted", area)

			crosshair_active = false
		
		is_player_inside = true


func _on_Area2D_area_exited(area):
	var groups = area.get_groups()
	
	if "Crosshair" in groups:
		crosshair_active = false
	
	if "Player" in groups:
		is_player_inside = false

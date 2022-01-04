extends Node2D

export var width = 10
export var height = 10

signal interacted(area)

func _on_Area2D_area_entered(area):
	var groups = area.get_groups()
	
	if "Player" in groups:
		emit_signal("interacted", area)

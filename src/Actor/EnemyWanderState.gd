extends "res://src/State/State.gd"

func update(delta):
	get_parent().get_node("DefaultState").update(delta)

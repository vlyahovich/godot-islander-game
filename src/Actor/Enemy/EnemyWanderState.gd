extends "res://src/State/State.gd"
class_name EnemyWanderState

func update(delta):
	get_parent().get_node("DefaultState").update(delta)

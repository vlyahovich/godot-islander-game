extends "res://src/State/State.gd"
class_name PlayerTurnState

func enter():
	var player = get_parent().get_parent()

	player.aTree.set("parameters/Turn/blend_position", player.dir.x)

func update(delta):
	var player = get_parent().get_parent()

	player.aTreeState.travel("Turn")

extends "res://src/State/State.gd"

func enter():
	var player = get_parent().get_parent()

	player.aTree.set("parameters/Death/blend_position", player.dir.x)

func update(delta):
	var player = get_parent().get_parent()

	player.aTreeState.travel("Death")
	
func _on_death_animation_finished():
	var player = get_parent().get_parent()
	
	player.queue_free()

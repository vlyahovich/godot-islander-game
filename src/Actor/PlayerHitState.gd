extends "res://src/State/State.gd"

func enter():
	var player = get_parent().get_parent()

	player.aTree.set("parameters/Hit/blend_position", player.hit_dir.x)

func update(delta):
	var player = get_parent().get_parent()

	player.aTreeState.travel("Hit")
	
func _on_hit_animation_finished():
	emit_signal("finished", "default")

extends "res://src/State/State.gd"
class_name PlayerTurnState

func enter():
	var player = get_player()

	player.aTree.set("parameters/Turn/blend_position", player.dir.x)
	player.aTree.set("parameters/Idle/blend_position", player.dir.x)
	player.aTree.set("parameters/Run/blend_position", player.dir.x)

	player.dustEmitter.emit_dust(player, player.dir)

	$TurnTime.start()
	
func get_player():
	return get_parent().get_parent()

func update(delta):
	var player = get_player()

	player.aTreeState.travel("Turn")

func _on_TurnTime_timeout():
	emit_signal("finished", "default")

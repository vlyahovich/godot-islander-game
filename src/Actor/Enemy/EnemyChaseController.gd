extends Node2D
class_name EnemyChaseController

var path = PoolVector2Array()
var navigation = null
var is_chasing = false

func _ready():
	navigation = Finder.get_level_navigation()

	$Line2D.set_as_toplevel(true)

func update_target_position():
	if navigation:
		path = navigation.get_simple_path(
			owner.global_position,
			owner.playerDetectionZone.player.global_position
		)

		$Line2D.points = path

func pop_path():
	path.remove(0)

func start_chasing():
	is_chasing = true

	update_target_position()

	$Timer.start()

func stop_chasing():
	is_chasing = false

func _on_Timer_timeout():
	if is_chasing:
		update_target_position()

		$Timer.start()

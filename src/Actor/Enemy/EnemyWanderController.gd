extends Node2D
class_name EnemyWanderController

export(int) var wander_range = 32

var path = PoolVector2Array()
var navigation = null

onready var start_position = global_position
onready var target_position = global_position

func _ready():
	navigation = Finder.get_level_navigation()

	update_target_position()

	$Line2D.set_as_toplevel(true)

func update_target_position():
	var target_vector = Vector2(
		rand_range(-wander_range, wander_range),
		rand_range(-wander_range, wander_range)
	)

	target_position = start_position + target_vector

	if navigation:
		path = navigation.get_simple_path(owner.global_position, target_position)

		target_position = path[path.size() - 1]

		$Line2D.points = path

func pop_path():
	path.remove(0)

func get_time_left():
	return $Timer.time_left

func start_wandering(duration):
	$Timer.start(duration)

func _on_Timer_timeout():
	update_target_position()

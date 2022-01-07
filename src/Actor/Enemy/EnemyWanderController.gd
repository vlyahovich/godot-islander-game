extends Node2D
class_name EnemyWanderController

export(int) var wander_range = 32

onready var start_position = global_position
onready var target_position = global_position

func _ready():
	update_target_position()

func update_target_position():
	var target_vector = Vector2(
		rand_range(-wander_range, wander_range),
		rand_range(-wander_range, wander_range)
	)

	target_position = start_position + target_vector

func get_time_left():
	return $Timer.time_left

func start_wandering(duration):
	$Timer.start(duration)

func _on_Timer_timeout():
	update_target_position()

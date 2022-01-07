extends "res://src/Actor/Enemy/EnemyBaseState.gd"
class_name EnemyDefaultState

func update(delta):
	var enemy: Enemy = owner.get_parent()
	
	basic_movement(delta)

	travel_idle_frames()

	enemy.seek_player()
	
	if enemy.wanderController.get_time_left() == 0:
		enemy.next_state()

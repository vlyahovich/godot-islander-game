extends "res://src/Actor/Enemy/EnemyBaseState.gd"
class_name EnemyWanderState

const acceleration = 300

func update(delta):
	var enemy: Enemy = owner.get_parent()
	var default_state: EnemyDefaultState = get_parent().get_node("DefaultState")

	basic_movement(delta)

	enemy.seek_player()

	if enemy.wanderController.get_time_left() == 0:
		enemy.next_state()

	if enemy.wanderController.path.size():
		var distance_to_walk = enemy.speed * delta

		follow_path(enemy.wanderController, distance_to_walk)
	else:
		var direction = enemy.global_position.direction_to(enemy.wanderController.target_position)

		update_enemy_direction(direction)
		travel_run_frames()

		enemy.velocity = enemy.velocity.move_toward(direction * enemy.speed, acceleration * delta)
		enemy.velocity = enemy.move_and_slide(enemy.velocity)
		
		if enemy.global_position.distance_to(enemy.wanderController.target_position) <= enemy.speed * delta:
			enemy.next_state()

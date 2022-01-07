extends "res://src/Actor/Enemy/EnemyBaseState.gd"
class_name EnemyChaseState

const acceleration = 300

func exit():
	var enemy = owner.get_parent()

	enemy.chaseController.stop_chasing()

func update(delta):
	var enemy = owner.get_parent()
	var player = enemy.playerDetectionZone.player
	var defaultState = get_parent().get_node("DefaultState");

	basic_movement(delta)

	if player == null:
		emit_signal("finished", "default")

	if player != null and enemy.stats.health != 0:
		if enemy.chaseController.path.size():
			var distance_to_walk = enemy.speed * delta

			follow_path(enemy.chaseController, distance_to_walk)
		else:
			var direction = enemy.global_position.direction_to(player.global_position)

			update_enemy_direction(direction)
			travel_run_frames()

			enemy.velocity = enemy.velocity.move_toward(direction * enemy.speed, acceleration * delta)
			enemy.velocity = enemy.move_and_slide(enemy.velocity)

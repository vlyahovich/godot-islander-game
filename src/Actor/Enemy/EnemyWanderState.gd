extends "res://src/State/State.gd"
class_name EnemyWanderState

const acceleration = 300

func update(delta):
	var enemy: Enemy = owner.get_parent()
	var default_state: EnemyDefaultState = get_parent().get_node("DefaultState")

	default_state.basic_movement(delta)

	enemy.seek_player()

	if !enemy.wanderController:
		return

	if enemy.wanderController.get_time_left() == 0:
		enemy.next_state()

	if enemy.wanderController.path.size():
		var path = enemy.wanderController.path
		var distance_to_walk = enemy.speed * delta
		var distance_to_next_point = enemy.position.distance_to(path[0])

		if distance_to_next_point == 0:
			enemy.wanderController.pop_path()
			return

		enemy.velocity = enemy.position.direction_to(path[0]) * enemy.speed

		if enemy.knockback == Vector2.ZERO:
			if enemy.dir == Vector2.RIGHT:
				enemy.animatedSprite.play("run_r")
			else:
				enemy.animatedSprite.play("run_l")

		if enemy.velocity.x > 0:
			enemy.dir = Vector2.RIGHT

		if enemy.velocity.x < 0:
			enemy.dir = Vector2.LEFT

		enemy.velocity = enemy.move_and_slide(enemy.velocity)

		if distance_to_walk > distance_to_next_point:
			enemy.position.x = path[0].x
			enemy.position.y = path[0].y
			enemy.velocity = Vector2.ZERO
			
			if enemy.knockback == Vector2.ZERO:
				if enemy.dir == Vector2.RIGHT:
					enemy.animatedSprite.play("idle_r")
				else:
					enemy.animatedSprite.play("idle_l")

			enemy.wanderController.pop_path()
	else:
		var direction = enemy.global_position.direction_to(enemy.wanderController.target_position)

		if direction.x > 0:
			enemy.dir = Vector2.RIGHT

		if direction.x < 0:
			enemy.dir = Vector2.LEFT
			
		if enemy.knockback == Vector2.ZERO:
			if enemy.dir == Vector2.RIGHT:
				enemy.animatedSprite.play("run_r")
			else:
				enemy.animatedSprite.play("run_l")

		enemy.velocity = enemy.velocity.move_toward(direction * enemy.speed, acceleration * delta)
		enemy.velocity = enemy.move_and_slide(enemy.velocity)
		
		if enemy.global_position.distance_to(enemy.wanderController.target_position) <= enemy.speed * delta:
			enemy.next_state()

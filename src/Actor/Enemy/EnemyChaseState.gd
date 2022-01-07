extends "res://src/State/State.gd"
class_name EnemyChaseState

const acceleration = 300

func exit():
	var enemy = owner.get_parent()

	enemy.chaseController.stop_chasing()

func update(delta):
	var enemy = owner.get_parent()
	var player = enemy.playerDetectionZone.player
	var defaultState = get_parent().get_node("DefaultState");

	defaultState.basic_movement(delta)
	
	if player == null:
		emit_signal("finished", "default")
	
	if player != null and enemy.stats.health != 0:
		if enemy.chaseController.path.size():
			var path = enemy.chaseController.path
			var distance_to_walk = enemy.speed * delta
			var distance_to_next_point = enemy.position.distance_to(path[0])

			if distance_to_next_point == 0:
				enemy.chaseController.pop_path()
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

				enemy.chaseController.pop_path()
		else:
			var distance = enemy.global_position.direction_to(player.global_position)
			var direction = distance.normalized()

			if distance.x > 0:
				enemy.dir = Vector2.RIGHT

			if distance.x < 0:
				enemy.dir = Vector2.LEFT
				
			if enemy.knockback == Vector2.ZERO:
				if enemy.dir == Vector2.RIGHT:
					enemy.animatedSprite.play("run_r")
				else:
					enemy.animatedSprite.play("run_l")

			enemy.velocity = enemy.velocity.move_toward(direction * enemy.speed, acceleration * delta)
			enemy.velocity = enemy.move_and_slide(enemy.velocity)

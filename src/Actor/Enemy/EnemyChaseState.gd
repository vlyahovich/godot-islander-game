extends "res://src/State/State.gd"
class_name EnemyChaseState

const acceleration = 300

func update(delta):
	var enemy = owner.get_parent()
	var player = enemy.playerDetectionZone.player
	var defaultState = get_parent().get_node("DefaultState");

	defaultState.basic_movement(delta)
	
	if player == null:
		emit_signal("finished", "default")
	
	if player != null and enemy.stats.health != 0:
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

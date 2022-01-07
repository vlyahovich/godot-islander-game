extends "res://src/State/State.gd"
class_name EnemyWanderState

const acceleration = 300

func update(delta):
	var enemy: Enemy = owner.get_parent()
	var default_state: EnemyDefaultState = get_parent().get_node("DefaultState")

	default_state.basic_movement(delta)

	enemy.seek_player()

	if enemy.wanderController.get_time_left() == 0:
		enemy.next_state()

	var distance = enemy.global_position.direction_to(enemy.wanderController.target_position)
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
	
	if enemy.global_position.distance_to(enemy.wanderController.target_position) <= enemy.speed * delta:
		enemy.next_state()

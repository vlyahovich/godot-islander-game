extends "res://src/State/State.gd"
class_name EnemyBaseState

func basic_movement(delta):
	var enemy: Enemy = owner.get_parent()
	
	enemy.knockback = enemy.knockback.move_toward(Vector2.ZERO, enemy.knockback_speed * delta)
	enemy.knockback = enemy.move_and_slide(enemy.knockback)
	
	enemy.velocity = enemy.velocity.move_toward(Vector2.ZERO, enemy.speed * delta)
	
	if enemy.stats.health == 0:
		if enemy.knockback == Vector2.ZERO:
			return

		if enemy.knockback.x > 0:
			enemy.animatedSprite.play("death_l")
		else:
			enemy.animatedSprite.play("death_r")

		return

	if enemy.knockback != Vector2.ZERO:
		if enemy.knockback.x > 0:
			enemy.animatedSprite.play("hit_l")
		else:
			enemy.animatedSprite.play("hit_r")

func update_enemy_direction(dir: Vector2):
	var enemy: Enemy = owner.get_parent()

	if dir.x > 0:
		enemy.dir = Vector2.RIGHT

	if dir.x < 0:
		enemy.dir = Vector2.LEFT

func follow_path(controller, distance_to_walk):
	var enemy: Enemy = owner.get_parent()
	var path = controller.path
	var distance_to_next_point = enemy.position.distance_to(path[0])

	if distance_to_next_point == 0:
		controller.pop_path()
		return

	enemy.velocity = enemy.position.direction_to(path[0]) * enemy.speed

	update_enemy_direction(enemy.velocity)
	travel_run_frames()

	enemy.velocity = enemy.move_and_slide(enemy.velocity)

	if distance_to_walk > distance_to_next_point:
		enemy.position.x = path[0].x
		enemy.position.y = path[0].y
		enemy.velocity = Vector2.ZERO
		
		travel_idle_frames()

		controller.pop_path()

func travel_idle_frames():
	var enemy: Enemy = owner.get_parent()

	if enemy.knockback == Vector2.ZERO:
		if enemy.dir == Vector2.RIGHT:
			enemy.animatedSprite.play("idle_r")
		else:
			enemy.animatedSprite.play("idle_l")
			
func travel_run_frames():
	var enemy: Enemy = owner.get_parent()

	if enemy.knockback == Vector2.ZERO:
		if enemy.dir == Vector2.RIGHT:
			enemy.animatedSprite.play("run_r")
		else:
			enemy.animatedSprite.play("run_l")

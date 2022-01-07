extends "res://src/State/State.gd"
class_name EnemyDefaultState

func update(delta):
	var enemy: Enemy = owner.get_parent()
	
	basic_movement(delta)
	
	if enemy.knockback == Vector2.ZERO:
		if enemy.dir == Vector2.RIGHT:
			enemy.animatedSprite.play("idle_r")
		else:
			enemy.animatedSprite.play("idle_l")

	enemy.seek_player()
	
	if enemy.wanderController.get_time_left() == 0:
		enemy.next_state()

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

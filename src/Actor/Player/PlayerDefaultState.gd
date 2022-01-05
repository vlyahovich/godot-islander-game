extends "res://src/State/State.gd"
class_name PlayerDefaultState

var min_velocity_length = 2

func update(delta):
	var player = get_parent().get_parent()
	var distance_to_walk = player.speed * delta
	
	if player.path.size():
		var distance_to_next_point = player.position.distance_to(player.path[0])

		if distance_to_next_point == 0:
			player.follow_path_pop()
			return

		var target_velocity = player.position.direction_to(player.path[0]) * player.speed

		player.aTree.set("parameters/Idle/blend_position", target_velocity.x)
		player.aTree.set("parameters/Run/blend_position", target_velocity.x)

#		player.velocity = lerp(player.velocity, target_velocity, delta * player.acceleration)
		player.velocity = target_velocity

		if player.velocity.x >= 0:
			player.dir = Vector2.RIGHT
		else:
			player.dir = Vector2.LEFT

		player.aTreeState.travel("Run")

		player.velocity = player.move_and_slide(player.velocity)

		if distance_to_walk > distance_to_next_point and player.position != player.path[0]:
			player.position.x = player.path[0].x
			player.position.y = player.path[0].y
			player.velocity = Vector2.ZERO
			player.aTreeState.travel("Idle")

			player.follow_path_pop()
		elif player.velocity.length() < min_velocity_length:
			print(1)
			# player is stuck in collision so we stop
			player.aTreeState.travel("Idle")
			player.follow_path_pop()
	else:
		player.aTreeState.travel("Idle")
		player.velocity = Vector2.ZERO

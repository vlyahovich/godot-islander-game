extends Node2D

func hit(dir):
	var current = $AnimationPlayer.current_animation
	
	$AudioStreamPlayer.play()
	
	$Sprite.visible = true

	if current == "hit_right" or current == "hit_left":
		$AnimationPlayer.stop()
	
	if dir == Vector2.RIGHT:
		position.x = -2
		position.y = -2
		
		$AnimationPlayer.play("hit_right")
	else:
		position.x = 2
		position.y = -2
		
		$AnimationPlayer.play("hit_left")

func _on_hit_animation_end():
	$Sprite.visible = false

	$AnimationPlayer.play("RESET")
	
	emit_signal("hit_ends")

signal hit_ends

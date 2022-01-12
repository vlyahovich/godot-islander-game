extends Node2D

signal hit_ends

func _ready():
	visible = false

func hit(dir):
	var current = $AnimationPlayer.current_animation

	visible = true

	if current == "hit_right" or current == "hit_left":
		$AnimationPlayer.stop()
	
	if dir.x >= 0:
		position.x = -2
		position.y = -3
		
		$AnimationPlayer.play("hit_right")
	else:
		position.x = 2
		position.y = -3
		
		$AnimationPlayer.play("hit_left")

func _input(_event):
	if Globals.dialogicActive:
		return

	if Input.is_action_just_pressed("ui_click_right"):
		$AnimationPlayer.play("RESET")

func _on_hit_animation_end():
	visible = false

	$AnimationPlayer.play("RESET")

	emit_signal("hit_ends")

extends Node2D

func _ready():
	$AnimationPlayer.play("animate")
	
func hide():
	$AnimationPlayer.play("hide")
	
func _on_hide_animation_finished():
	queue_free()

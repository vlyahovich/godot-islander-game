extends Node2D

export(Array) var levelSprites = []

var level = 1 setget set_level
var max_level = 5

var upgradeCosts = [
	[[ResourceMap.WOOD, 100], [ResourceMap.STONE, 100]],
	[[ResourceMap.WOOD, 200], [ResourceMap.STONE, 200]],
	[[ResourceMap.WOOD, 300], [ResourceMap.STONE, 300]],
	[[ResourceMap.WOOD, 400], [ResourceMap.STONE, 400]],
]

signal hit_ends

func _ready():
	visible = false

	set_level(level)

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

func set_level(value):
	level = clamp(value, 1, max_level)
	
	$Sprite.frame = levelSprites[level - 1]

func _input(_event):
	if Globals.dialogicActive:
		return

	if Input.is_action_just_pressed("ui_click_right"):
		$AnimationPlayer.play("RESET")

func _on_hit_animation_end():
	visible = false

	$AnimationPlayer.play("RESET")

	emit_signal("hit_ends")

tool
extends StaticBody2D

export var speed_scale = 2

func _ready():
	var animated_sprites = [
		$AnimatedSprite3,
		$AnimatedSprite4,
		$AnimatedSprite8,
		$AnimatedSprite9,
		$AnimatedSprite10,
		$AnimatedSprite11
	]

	for sprite in animated_sprites:
		sprite.frame = 0
		sprite.speed_scale = speed_scale
		sprite.play()

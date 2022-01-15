tool
extends StaticBody2D

export var variant: int = 0 setget set_variant

var variants_map = [17, 18, 19, 20, 28, 29, 30, 31]
var ready = false

func _ready():
	ready = true

	_apply_variant()
	
func set_variant(value):
	variant = value

	if ready:
		_apply_variant()

func _apply_variant():
	var variant_clamped = clamp(variant, 0, variants_map.size() - 1)

	$Sprite.frame = variants_map[variant_clamped]

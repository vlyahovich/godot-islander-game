tool
extends Node2D

export var variant: int = 0 setget set_variant

var variants_map = [13, 14, 15, 16, 24, 25, 26, 27]

func _ready():
	_apply_variant()
	
func set_variant(value):
	variant = value

	_apply_variant()

func _apply_variant():
	var variant_clamped = clamp(variant, 0, variants_map.size() - 1)

	$Sprite.frame = variants_map[variant_clamped]

tool
extends StaticBody2D

export var variant: int = 0 setget set_variant

var variants_map = [81, 82]
var ready = false

func _ready():
	ready = true

	_apply_variant()
	
func set_variant(value):
	if !ready:
		return

	variant = value

	_apply_variant()

func _apply_variant():
	var variant_clamped = clamp(variant, 0, variants_map.size() - 1)

	$Sprite.frame = variants_map[variant_clamped]
	
	if variant_clamped == 0:
		$CollisionShapeRock.disabled = false
		$CollisionShapeRocks.disabled = true
	if variant_clamped == 1:
		$CollisionShapeRock.disabled = true
		$CollisionShapeRocks.disabled = false

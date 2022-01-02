tool
extends StaticBody2D

export var variant: int = 0 setget set_variant

var variant1 = [53, 54, 68, 69, 82, 0]
var variant2 = [98, 99, 113, 114, 28]

func _ready():
	_apply_variant()
	
func set_variant(value):
	variant = value

	_apply_variant()

func _apply_variant():
	var variant_clamped = clamp(variant, 0, 1)
	
	if variant_clamped == 0:
		$SignLeft.visible = true
		$SignRight.visible = false
	else:
		$SignLeft.visible = false
		$SignRight.visible = true

tool
extends StaticBody2D

export var variant: int = 1 setget set_variant

const topVariants: Array = [34, 35, 38]
const bottomVariants: Array = [45, 46, 49]

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
	var variant_clamped = clamp(variant, 0, topVariants.size() - 1)

	if get_node_or_null("Top"):
		$Top.frame = topVariants[variant_clamped]

	if get_node_or_null("Bottom"):
		$Bottom.frame = bottomVariants[variant_clamped]

func _get_crosshair():
	return get_tree().current_scene.get_node_or_null("Crosshair")

func _on_Interactable_interacted(area):
	print("break the tree")

func _on_Interactable_interacted_coursor(area):
	if $Interactable.is_player_inside:
		print("knock the tree")

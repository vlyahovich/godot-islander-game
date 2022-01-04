tool
extends StaticBody2D

export var variant: int = 1 setget set_variant

const topVariants: Array = [34, 35, 38]
const bottomVariants: Array = [45, 46, 49]

var ready = false
var interactable = true

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

func _get_resource_emitter():
	return get_tree().current_scene.get_node_or_null("ResourceEmitter")

func _on_Interactable_interacted(area):
	if $Interactable.active:
		$Stats.health -= 1
		
		if $Stats.health <= 0:
			$Stats.health = 3
			$Interactable.active = false
			$AnimationPlayer.play("break")
			$GrowTimer.start()

			_get_resource_emitter().emit_count(self, 3)
			
			yield($AnimationPlayer, "animation_finished")
			
			$Sprite.scale = Vector2(1, 1)
			$Sprite.modulate = Color(1, 1, 1, 0.2)
		else:
			$AnimationPlayer.play("break")

			yield($AnimationPlayer, "animation_finished")
			
			$AnimationPlayer.play("RESET")

func _on_Interactable_interacted_coursor(area):
	_on_Interactable_interacted(area)

func _on_GrowTimer_timeout():
	$Interactable.active = true
	$AnimationPlayer.play("grow")

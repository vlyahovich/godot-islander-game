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

func _on_Interactable_interacted(_area):
	if $Interactable.active:
		$Stats.health -= 1

func _on_GrowTimer_timeout():
	$Interactable.active = true
	$AnimationPlayer.play("grow")

func _on_Stats_health_depleted():
	if $Interactable.active:
		$Stats.reset_health()
		$Interactable.active = false
		$AnimationPlayer.play("break")
		$GrowTimer.start()

		Finder.get_resource_emitter().emit_count(self, 3, ResourceMap.WOOD)

		yield($AnimationPlayer, "animation_finished")

		$Sprite.scale = Vector2(1, 1)
		$Sprite.modulate = Color(1, 1, 1, 0.2)

func _on_Stats_health_chaged(value):
	if value > 0:
		$AnimationPlayer.play("break")

		yield($AnimationPlayer, "animation_finished")
		
		$AnimationPlayer.play("RESET")

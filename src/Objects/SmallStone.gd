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

func _on_Interactable_interacted(area):
	if $Interactable.active:
		area.notify_interaction_started(ResourceMap.STONE, 0.2)

		$InteractionTimer.start()

		yield($InteractionTimer, "timeout")

		area.notify_interaction_finished(ResourceMap.STONE, 0.2)

		$Stats.health -= 1

func _on_RepairTimer_timeout():
	$Stats.reset_health()
	$Interactable.active = true
	$GrowSound.play()
	$AnimationPlayer.play("repair")

func _on_Stats_health_depleted():
	if $Interactable.active:
		$Interactable.active = false
		$BreakSound.play()
		$AnimationPlayer.play("break")
		$RepairTimer.start()

		Finder.get_resource_emitter().emit_count(self, 1, ResourceMap.STONE)

		yield($AnimationPlayer, "animation_finished")

		$Sprite.scale = Vector2(1, 1)
		$Sprite.modulate = Color(1, 1, 1, 0.2)

func _on_Stats_health_chaged(value):
	if value > 0:
		$HitSound.play()
		$AnimationPlayer.play("break")

		yield($AnimationPlayer, "animation_finished")
		
		$AnimationPlayer.play("RESET")

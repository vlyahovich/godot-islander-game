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

func _on_Interactable_interacted(_area):
	if $Interactable.active:
		$Stats.health -= 1

func _on_RepairTimer_timeout():
	$Interactable.active = true
	$AnimationPlayer.play("repair")

func _on_Stats_health_depleted():
	if $Interactable.active:
		$Stats.reset_health()
		$Interactable.active = false
		$AnimationPlayer.play("break")
		$RepairTimer.start()

		Finder.get_resource_emitter().emit_count(self, 1, ResourceMap.STONE)

		yield($AnimationPlayer, "animation_finished")

		$Sprite.scale = Vector2(1, 1)
		$Sprite.modulate = Color(1, 1, 1, 0.2)

func _on_Stats_health_chaged(value):
	if value > 0:
		$AnimationPlayer.play("break")

		yield($AnimationPlayer, "animation_finished")
		
		$AnimationPlayer.play("RESET")

extends StaticBody2D

func _on_Interactable_interacted(area):
	if $Interactable.active:
		area.notify_interaction_started(ResourceMap.STONE, 0.5)

		$InteractionTimer.start()

		yield($InteractionTimer, "timeout")

		area.notify_interaction_finished(ResourceMap.STONE, 0.5)

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

		Finder.get_resource_emitter().emit_count(self, 3, ResourceMap.STONE)

		yield($AnimationPlayer, "animation_finished")

		$Sprite.scale = Vector2(1, 1)
		$Sprite.modulate = Color(1, 1, 1, 0.2)

func _on_Stats_health_chaged(value):
	if value > 0:
		$HitSound.play()
		$AnimationPlayer.play("break")

		yield($AnimationPlayer, "animation_finished")
		
		$AnimationPlayer.play("RESET")

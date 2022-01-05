extends StaticBody2D

func _on_Interactable_interacted(area):
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

		Finder.get_resource_emitter().emit_count(self, 3, ResourceMap.STONE)

		yield($AnimationPlayer, "animation_finished")

		$Sprite.scale = Vector2(1, 1)
		$Sprite.modulate = Color(1, 1, 1, 0.2)


func _on_Stats_health_chaged(value):
	if value > 0:
		$AnimationPlayer.play("break")

		yield($AnimationPlayer, "animation_finished")
		
		$AnimationPlayer.play("RESET")

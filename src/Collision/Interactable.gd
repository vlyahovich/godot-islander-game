extends Node2D

var crosshair_active = false
var player_area = null
var active = true setget set_active

signal interacted(area)

func set_active(value):
	active = value
	
	if active:
		$Area2D/CollisionShape2D.set_deferred("disabled", false)
	else:
		$Area2D/CollisionShape2D.set_deferred("disabled", true)
		
func _notify_interacted(area):
	if $CooldownTimer.is_stopped():
		$CooldownTimer.start()
		emit_signal("interacted", area)

func _on_Area2D_area_entered(area):
	var groups = area.get_groups()

	if "Crosshair" in groups:
		if player_area:
			_notify_interacted(player_area)

		crosshair_active = true
	
	if "Player" in groups:
		if crosshair_active:
			_notify_interacted(area)

			crosshair_active = false
		
		player_area = area

func _on_Area2D_area_exited(area):
	var groups = area.get_groups()
	
	if "Crosshair" in groups:
		crosshair_active = false
	
	if "Player" in groups:
		player_area = null

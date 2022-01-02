extends Area2D

var invincible = false setget set_invincible
var active = true setget set_active

signal invincibility_started
signal invincibility_ended

func set_invincible(value):
	invincible = value
	
	if invincible == true:
		emit_signal("invincibility_started")
	else:
		emit_signal("invincibility_ended")
		
func start_invincibility(duration):
	if invincible == false:
		$InvincibilityTimer.start(duration)

		self.invincible = true

func _on_InvincibilityTimer_timeout():
	self.invincible = false

func _on_Hurtbox_invincibility_started():
	if not active:
		return

	set_deferred("monitorable", false)
	set_deferred("monitoring", false)

func _on_Hurtbox_invincibility_ended():
	if not active:
		return

	monitorable = true
	monitoring = true
	
func set_active(value):
	active = value

	if value == true:
		set_deferred("monitorable", true)
		set_deferred("monitoring", true)
	else:
		set_deferred("monitorable", false)
		set_deferred("monitoring", false)

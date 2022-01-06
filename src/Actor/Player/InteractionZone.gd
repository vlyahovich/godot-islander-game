extends Area2D

signal interaction_finished(strength)
signal rested()

func notify_interaction_finished(strength):
	emit_signal("interaction_finished", strength)

func notify_rested():
	emit_signal("rested")

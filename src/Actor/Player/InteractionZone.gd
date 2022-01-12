extends Area2D

signal interaction_started(strength)
signal interaction_finished(strength)
signal rested()

func notify_interaction_started(resource, strength):
	var player: Player = owner

	if resource in [ResourceMap.WOOD]:
		player.axe.hit(player.dir)

	if resource in [ResourceMap.STONE]:
		player.pickaxe.hit(player.dir)

	emit_signal("interaction_started", strength)

func notify_interaction_finished(_resource, strength):
	emit_signal("interaction_finished", strength)

func notify_rested():
	emit_signal("rested")

extends Area2D

const axe_resources = [ResourceMap.WOOD]
const pickaxe_resources = [ResourceMap.STONE]

onready var player: Player = owner

signal interaction_started(strength)
signal interaction_finished(strength)
signal rested()

func notify_interaction_started(resource, strength):
	if resource in axe_resources:
		player.axe.hit(player.dir)

	if resource in pickaxe_resources:
		player.pickaxe.hit(player.dir)

	emit_signal("interaction_started", strength)

func notify_interaction_finished(_resource, strength):
	emit_signal("interaction_finished", strength)

func notify_rested():
	emit_signal("rested")

func damage_resource(resource) -> int:
	if resource in axe_resources:
		return player.axe.level

	if resource in pickaxe_resources:
		return player.pickaxe.level

	return 1

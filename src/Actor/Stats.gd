extends Node
class_name Stats

export var max_health = 1.0
export var max_stamina = 1.0
export var toughness = 0

onready var health = max_health setget set_health
onready var stamina = max_stamina setget set_stamina

signal health_depleted
signal health_chaged(value)
signal health_endured(value)

signal stamina_depleted
signal stamina_changed(value)

func set_health(value):
	var diff = value - health
	
	if diff < 0:
		diff = clamp(diff + toughness, -max_health, 0)

	if diff != 0:
		health = clamp(health + diff, 0, max_health)

		emit_signal("health_chaged", health)
	else:
		emit_signal("health_endured", health)
	
	if health <= 0:
		emit_signal("health_depleted")
		
func reset_health():
	self.health = max_health

func set_stamina(value):
	stamina = clamp(value, 0, max_stamina)
	
	emit_signal("stamina_changed", stamina)
	
	if stamina <= 0:
		emit_signal("stamina_depleted")
		
func reset_stamina():
	self.stamina = max_stamina

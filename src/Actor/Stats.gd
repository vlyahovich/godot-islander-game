extends Node

export var max_health: int = 1
export var max_stamina: int = 1

onready var health = max_health setget set_health
onready var stamina = max_stamina setget set_stamina

signal health_depleted
signal health_chaged(value)

signal stamina_depleted
signal stamina_chaged(value)

func set_health(value):
	health = clamp(value, 0, max_health)
	
	emit_signal("health_chaged", health)
	
	if health <= 0:
		emit_signal("health_depleted")
		
func reset_health():
	health = max_health
	
func set_stamina(value):
	stamina = clamp(value, 0, max_stamina)
	
	emit_signal("stamina_chaged", stamina)
	
	if stamina <= 0:
		emit_signal("stamina_depleted")
		
func reset_stamina():
	stamina = max_stamina

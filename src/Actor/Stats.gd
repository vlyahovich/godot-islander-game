extends Node

export var max_health: int = 1

onready var health = max_health setget set_health

signal health_depleted
signal health_chaged(value)

func set_health(value):
	health = clamp(value, 0, max_health)
	
	emit_signal("health_chaged", health)
	
	if health <= 0:
		emit_signal("health_depleted")
		
func reset_health():
	health = max_health

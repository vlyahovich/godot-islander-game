extends Node

var FootDust = preload("res://src/Effects/FootDust.tscn")
var dustOffsetX = 6
var dustOffsetY = -2
var dustDuration = 1
var alongDust = FootDust.instance()

func emit_dust(actor, dir):
	var timer = Timer.new()
	var footDust = FootDust.instance()
	
	timer.wait_time = dustDuration

	add_child(timer)

	actor.add_child(footDust)

	footDust.one_shot = true
	footDust.emitting = true
	footDust.global_position = actor.global_position

	if dir and dir.x > 0:
		footDust.rotation_degrees = -90
		footDust.global_position = footDust.global_position - Vector2(dustOffsetX, dustOffsetY)
	else:
		footDust.rotation_degrees = 0
		footDust.global_position = footDust.global_position - Vector2(-dustOffsetX, dustOffsetY)

	timer.start()

	yield(timer, "timeout")

	timer.queue_free()
	footDust.queue_free()
	

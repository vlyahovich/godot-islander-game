extends Node

var items = []
var counts = []

signal resources_updated()

func _ready():
	var resource_emitter = Finder.get_resource_emitter()

	if resource_emitter:
		resource_emitter.connect("resource_received", self, "_resource_received")

func connect_emitter(emitter) -> void:
	if emitter:
		emitter.connect("resource_received", self, "_resource_received")

func use_resources(list: Array, listCounts: Array) -> bool:
	var i = 0
	
	if !has_enough_resources(list, listCounts):
		return false

	for item in list:
		var index = items.find(item)

		if index != -1:
			counts[index] = clamp(counts[index] - listCounts[i], 0, 999)
			
			if counts[index] == 0:
				items.remove(index)
				counts.remove(index)

		i += 1

	emit_signal("resources_updated")

	return true
	
func has_enough_resources(list: Array, listCounts: Array) -> bool:
	var i = 0
	var enough = true

	for item in list:
		var index = items.find(item)
		
		if index == -1 or counts[index] < listCounts[i]:
			enough = false

			break

		i += 1

	return enough

func _resource_received(meta):
	var index = items.find(meta)

	if index == -1:
		items.append(meta)
		counts.append(1)

		_update_dialogic(meta, 1)
	else:
		counts[index] = clamp(counts[index] + 1, 0, 999)

		_update_dialogic(meta, counts[index])

	$PopSound.play()

	emit_signal("resources_updated")
	
func _update_dialogic(meta, count):
	Dialogic.set_variable(meta.definition, count)

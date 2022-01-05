extends Node

var items = []
var counts = []

signal resources_updated()

func _ready():
	var resource_emitter = Finder.get_resource_emitter()

	if resource_emitter:
		resource_emitter.connect("resource_received", self, "_resource_received")

func connect_emitter(emitter):
	if emitter:
		emitter.connect("resource_received", self, "_resource_received")

func _resource_received(meta):
	var index = items.find(meta)

	if index == -1:
		items.append(meta)
		counts.append(1)
	else:
		counts[index] = clamp(counts[index] + 1, 0, 999)

	$PopSound.play()

	emit_signal("resources_updated")

extends Node

var items = []
var counts = []

func _ready():
	DebugOverlay.add_stat("Inventory items", self, "to_string", true)

	var resource_emitter = Finder.get_resource_emitter()

	if resource_emitter:
		resource_emitter.connect("resource_received", self, "_resource_received")

func store_item(meta):
	pass
	
func to_string():
	var to_str = ""
	var i = 0

	for meta in items:
		to_str += meta.type
		to_str += ": "
		to_str += str(counts[i])
		to_str += ";"
		
		i += 1

	return to_str if to_str else "empty"

func _resource_received(meta):
	var index = items.find(meta)
	
	if index == -1:
		items.append(meta)
		counts.append(1)
	else:
		counts[index] += 1

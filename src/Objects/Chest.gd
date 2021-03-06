tool
extends StaticBody2D

export var open: bool = false setget set_open

var open_frames = [69, 80]
var closed_frames = [68, 79]

var empty = false

func set_open(value):
	open = value
	
	if open:
		$Top.frame = open_frames[0]
		$Bottom.frame = open_frames[1]
	else:
		$Top.frame = closed_frames[0]
		$Bottom.frame = closed_frames[1]

func _on_Interactable_interacted(area):
	self.open = !open

	if open:
		area.notify_interaction_finished(null, 0)

		$OpenSound.play()
		
		if !empty:
			Finder.get_resource_emitter().emit_count(self, 10, ResourceMap.WOOD)
			Finder.get_resource_emitter().emit_count(self, 10, ResourceMap.STONE)

		empty = true
	else:
		$CloseSound.play()

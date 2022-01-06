extends Node2D

func _ready():
	PlayerInventory.connect("resources_updated", self, "_resources_updated")

	_update_ui()

func _resources_updated():
	_update_ui()

func _update_ui():
	var items = PlayerInventory.items
	var counts = PlayerInventory.counts
	var slot = 1
	
	for node in get_children():
		var sprite = node.get_node("ResourceSprite")
		var count = node.get_node("Count")

		sprite.visible = false
		count.visible = false

	for meta in items:
		var node = get_node_or_null("Slot" + str(slot))

		if node and counts[slot - 1]:
			var sprite = node.get_node("ResourceSprite")
			var count = node.get_node("Count")

			sprite.frame = meta.sprite
			sprite.visible = true
			
			if counts[slot - 1] > 1:
				count.text = str(counts[slot - 1])
				count.visible = true
			else:
				count.text = ""
				count.visible = false

		slot += 1

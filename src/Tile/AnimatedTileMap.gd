extends TileMap

export(int) var frame_count = 4
export(int) var frame_shift = 7
export(float) var frame_time = 0.25
export(Array) var cells = [0]

var frame = 0

func _ready():
	# we make a copy here because we do not want to affect other tilemaps
	tile_set = tile_set.duplicate()

	if get_node_or_null("AnimateTimer"):
		$AnimateTimer.connect("timeout", self, "_next_frame")
		$AnimateTimer.start()
	else:
		var timer = Timer.new()
	
		timer.wait_time = frame_time
		timer.connect("timeout", self, "_next_frame")
	
		add_child(timer)
	
		timer.start()

func _next_frame():
	frame = (frame + 1) % frame_count

	if frame == 0:
		for cell in cells:
			var region = tile_set.tile_get_region(cell)
			var region_shift = cell_size.y * frame_shift * (frame_count - 1)
			var new_position = Vector2(region.position.x, region.position.y - region_shift)

			tile_set.tile_set_region(cell, Rect2(new_position, cell_size))
	else:
		for cell in cells:
			var region = tile_set.tile_get_region(cell)
			var region_shift = cell_size.y * frame_shift
			var new_position = Vector2(region.position.x, region.position.y + region_shift)

			tile_set.tile_set_region(cell, Rect2(new_position, cell_size))

extends TileMap

var frame = 0
export var frame_count = 4
export var frame_shift = 7
export var frame_time = 0.25

func _ready():
	# we make a copy here because we do not want to affect other tilemaps
	tile_set = tile_set.duplicate()

	if get_node_or_null("AnimateTimer"):
		# warning-ignore:return_value_discarded
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
	
	var cells = []
	
	for v2 in get_used_cells():
		var cell_id = get_cell(v2.x, v2.y)
		
		if !cells.has(cell_id):
			cells.push_back(cell_id)
	
	
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

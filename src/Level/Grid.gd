extends Node2D

export(bool) var on = true
export(int) var cell_count = 100
export(int) var cell_size = 16
export(Color) var line_color = Color.darkslateblue

func _draw():
	if on:
		var origin = Vector2(
			-(cell_size * (cell_count / 2)),
			-(cell_size * (cell_count / 2))
		)
		var color = line_color.to_html(false)

		# horizontal
		for i in range(0, cell_count + 1):
			draw_line(
				Vector2(origin.x, origin.y + cell_size * i),
				Vector2(origin.x + cell_size * cell_count, origin.y + cell_size * i),
				color
			)

		# vertical
		for i in range(0, cell_count + 1):
			draw_line(
				Vector2(origin.x + cell_size * i, origin.y),
				Vector2(origin.x + cell_size * i, origin.y + cell_size * cell_count),
				color
			)

func _process(delta):
	update()

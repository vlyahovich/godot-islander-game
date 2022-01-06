extends Node2D

var stats: Stats = null
var cell_width = 4

func init(player: Player, crosshair: Crosshair):
	stats = player.stats

	stats.connect("health_chaged", self, "_health_changed")
	stats.connect("stamina_changed", self, "_stamina_changed")

	crosshair.connect("interaction_reached", self, "_interaction_reached")

	_health_changed(stats.health)
	_stamina_changed(stats.stamina)
	
func _interaction_reached(area):
	if area and "Resource" in area.get_groups() and stats.stamina == 0:
		$AnimationPlayer.play("no_stamina")
	
func _health_changed(health):
	_fill_bar($Health/Empty, stats.max_health, [4, 5, 6])
	_fill_bar($Health/Fill, ceil(health), [0, 1, 2])
	
func _stamina_changed(stamina):
	_fill_bar($Stamina/Empty, stats.max_stamina, [11, 12, 13])
	_fill_bar($Stamina/Fill, ceil(stamina), [7, 8, 9])

func _fill_bar(bar: Node2D, value: int, frames: Array):
	var max_cells = bar.get_children().size()
	var start = bar.get_node("Cell1").position
	var pos = start.x

	for i in range(0, max_cells):
		var cell = bar.get_node_or_null("Cell" + str(i + 1))

		if !cell:
			continue

		# visibility
		if i < value:
			cell.visible = true
		else:
			cell.visible = false

		# frames
		if i == value - 1 and i != 0:
			cell.frame = frames[2]
		elif i == 0:
			cell.frame = frames[0]
		else:
			cell.frame = frames[1]
			
		# positions
		cell.position.x = pos

		if i < 1 or i == value - 2:
			pos += cell_width
		else:
			pos += cell_width - 1

	var helper_cell = bar.get_node_or_null("Cell0")

	# edge cases
	if helper_cell:
		helper_cell.visible = true
		helper_cell.frame = frames[2]

		if value == 0:
			helper_cell.visible = false
		elif value == 2:
			var second_cell = bar.get_node_or_null("Cell2")

			if second_cell:
				second_cell.position.x = second_cell.position.x + 1

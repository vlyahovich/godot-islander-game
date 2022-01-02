extends Node2D

export(NodePath) var stats_path

func _ready():
	var stats = get_node(stats_path)

	stats.connect("health_chaged", self, "_stats_health_changed")
	
	_update_width(stats.health)
	
func _update_width(health):
	var stats = get_node(stats_path)
	var friction = 0 if stats.max_health <= 0 else float(health) / stats.max_health
	var bar_width = abs($Background.points[0].distance_to($Background.points[1]))
	var fill_width = friction * bar_width
	
	if fill_width == 0:
		queue_free()
	
	$Fill.points[1] = $Fill.points[0] + Vector2(fill_width, 0)

func _stats_health_changed(value):
	_update_width(value)

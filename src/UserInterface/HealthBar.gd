extends Node2D

export(NodePath) var stats_path

const tween_duration = 0.2

var stats: Stats = null
var changed = false

func _ready():
	stats = get_node(stats_path)

	stats.connect("health_chaged", self, "_stats_health_changed")
	stats.connect("health_depleted", self, "_stats_health_depleted")

	modulate = Color.transparent

	_stats_health_changed(stats.health)

func _stats_health_changed(value):
	$TextureProgress.value = (float(value) / stats.max_health) * 100

	if value != stats.max_health:
		$Tween.interpolate_property(
			self,
			"modulate",
			modulate,
			Color.white,
			tween_duration,
			Tween.TRANS_LINEAR,
			Tween.EASE_IN
		)
		$Tween.start()

func _stats_health_depleted():
	$Tween.interpolate_property(
		self,
		"modulate",
		modulate,
		Color.transparent,
		tween_duration,
		Tween.TRANS_LINEAR,
		Tween.EASE_OUT
	)
	$Tween.start()
	
	yield($Tween, "tween_completed")

	queue_free()

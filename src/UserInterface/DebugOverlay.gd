extends CanvasLayer

var stats = []

func _ready():
	add_stat("FPS", Engine, "get_frames_per_second", true)
	add_stat("Memory", self, "_get_memory_in_mb", true)
	
func _process(_delta):
	var label_text = ""
	
	for s in stats:
		var value = null
		
		if s[1] and weakref(s[1]).get_ref():
			if s[3]:
				value = s[1].call(s[2])
			else:
				value = s[1].get(s[2])
		
		if typeof(value) == TYPE_VECTOR2:
			value = "(" + str(stepify(value.x, 0.01)) + ", " +  str(stepify(value.y, 0.01)) + ")"
		
		if value != null:
			if label_text != "":
				label_text += "\n"
			label_text += str(s[0], ": ", value)
	
	$Node2D/Control/PanelContainer/Label.text = label_text
	
func add_stat(stat_name, object, stat_ref, is_method):
	stats.append([stat_name, object, stat_ref, is_method])
	
func _get_memory_in_mb():
	return str(stepify(float(OS.get_static_memory_usage()) / 1024 / 1024, 0.01)) + "MB"

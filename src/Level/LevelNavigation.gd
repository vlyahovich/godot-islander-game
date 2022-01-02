extends Navigation2D

var pressed = false

export(NodePath) var player_path = null

func _ready():
	assert(player_path != null, "you must provide player_path")

func _navigate_to_mouse():
	if $InputTimer.is_stopped():
		$InputTimer.start()
		
		var player = get_node(player_path)
	
		if player: 
			var path = get_simple_path(player.position, get_local_mouse_position())
		
			player.follow_path(path)

func _unhandled_input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT:
			pressed = event.pressed
			
			if pressed:
				_navigate_to_mouse()
	
	if event is InputEventMouseMotion and pressed:
		_navigate_to_mouse()

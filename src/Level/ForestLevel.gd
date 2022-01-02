extends Node2D

var pressed = false

func _ready():
	$LevelMusic.play()
	
func _navigate_to_mouse():
	if $InputTimer.is_stopped():
		$InputTimer.start()

		var player = null
		
		if get_node_or_null("YSort/Player"):
			player = $YSort/Player
		if get_node_or_null("Player"):
			player = $Player
	
		if player: 
			var path = $Navigation2D.get_simple_path(player.position, get_local_mouse_position())
		
			player.follow_path(path)

func _unhandled_input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT:
			pressed = event.pressed
			
			if pressed:
				_navigate_to_mouse()
	
	if event is InputEventMouseMotion and pressed:
		_navigate_to_mouse()

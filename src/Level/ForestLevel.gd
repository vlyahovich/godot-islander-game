extends Node2D

func _ready():
	#todo: remove mute
	AudioServer.set_bus_mute(AudioServer.get_bus_index("Master"), true)

	$LevelMusic.play()

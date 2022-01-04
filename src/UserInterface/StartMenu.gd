extends CanvasLayer

func _ready():
	get_tree().change_scene("res://src/Level/ForestLevel.tscn")
	var master_sound = AudioServer.get_bus_index("Master")
	AudioServer.set_bus_mute(master_sound, true)
	return

	$Welcome.visible = true
	$Credits.visible = false
	$SoundButtonOff.visible = true
	$SoundButtonOn.visible = false

	if GameSettings.mute_sound == true:
		_on_SoundButtonOff_pressed()

	$MenuMusic.play()


func _on_PlayButton_pressed():
	$MenuMusic.stop()
	$PlayButtonSound.play()
	
	$Timer.start()
	
	yield($Timer, "timeout")

	get_tree().change_scene("res://src/Level/ForestLevel.tscn")


func _on_CreditsButton_pressed():
	$ButtonsSound.play()

	$Welcome.visible = false
	$Credits.visible = true


func _on_BackButton_pressed():
	$ButtonsSound.play()

	$Welcome.visible = true
	$Credits.visible = false


func _on_SoundButtonOff_pressed():
	$ButtonsSound.play()

	$SoundButtonOff.visible = false
	$SoundButtonOn.visible = true
	
	var master_sound = AudioServer.get_bus_index("Master")
	
	AudioServer.set_bus_mute(master_sound, true)

	$MenuMusic.stream_paused = true

func _on_SoundButtonOn_pressed():
	$ButtonsSound.play()

	$SoundButtonOff.visible = true
	$SoundButtonOn.visible = false
	
	var master_sound = AudioServer.get_bus_index("Master")
	
	AudioServer.set_bus_mute(master_sound, false)
	
	$MenuMusic.stream_paused = false

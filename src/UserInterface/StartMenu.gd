extends CanvasLayer

export var skip_menu = false

func _ready():
	if GameSettings.mute_sound == true:
		_on_SoundButtonOff_pressed()
	else:
		$SoundButtonOff.visible = true
		$SoundButtonOn.visible = false

	if skip_menu:
		get_tree().change_scene("res://src/Level/ForestLevel.tscn")
	else:
		$FadeLayer/ScreenFader.fade_in()

		$Welcome.visible = true
		$Credits.visible = false

		$MenuMusic.play()
		$AnimationPlayer.play("pop")

func _on_PlayButton_pressed():
	$AnimationPlayer.play_backwards("pop")
	$MenuMusic.stop()
	$PlayButtonSound.play()
	
	$FadeLayer/ScreenFader.fade_out()

	yield($FadeLayer/ScreenFader, "animation_finished")

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

	GameSettings.mute_sound = true

	var master_sound = AudioServer.get_bus_index("Master")
	
	AudioServer.set_bus_mute(master_sound, true)

	$MenuMusic.stream_paused = true

func _on_SoundButtonOn_pressed():
	$ButtonsSound.play()

	$SoundButtonOff.visible = true
	$SoundButtonOn.visible = false

	GameSettings.mute_sound = false

	var master_sound = AudioServer.get_bus_index("Master")
	
	AudioServer.set_bus_mute(master_sound, false)
	
	$MenuMusic.stream_paused = false


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "pop":
		$AnimationPlayer.play("idle")

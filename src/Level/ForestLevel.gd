extends Node2D

func _ready():
	$FadeLayer/ScreenFader.fade_in()

	PlayerInventory.connect_emitter($ResourceEmitter)

	$LevelMusic.play()

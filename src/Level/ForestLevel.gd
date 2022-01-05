extends Node2D

func _ready():
	PlayerInventory.connect_emitter($ResourceEmitter)

	#$LevelMusic.play()

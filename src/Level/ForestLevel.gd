extends Node2D

export(NodePath) var player_path
export(NodePath) var crosshair_path

func _ready():
	var player: Player = get_node(player_path)
	var crosshair: Crosshair = get_node(crosshair_path)

	$FadeLayer/ScreenFader.fade_in()

	PlayerInventory.connect_emitter($ResourceEmitter)
	
	$HUD.init(player, crosshair)

	$LevelMusic.play()

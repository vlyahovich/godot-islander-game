extends Node

func get_resource_emitter() -> ResourceEmitter:
	return get_tree().current_scene.get_node_or_null("ResourceEmitter") as ResourceEmitter

func get_level_navigation() -> LevelNavigation:
	return get_tree().current_scene.get_node_or_null("LevelNavigation") as LevelNavigation

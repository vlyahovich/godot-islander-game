extends Node

func get_resource_emitter() -> ResourceEmitter:
	return get_tree().current_scene.get_node_or_null("ResourceEmitter") as ResourceEmitter

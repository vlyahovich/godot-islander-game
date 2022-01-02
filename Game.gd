extends Node2D

func _init():
	OS.min_window_size = OS.window_size
	OS.max_window_size = OS.get_screen_size()

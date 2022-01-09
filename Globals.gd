extends Node

var dialogicActive: bool = false

func dialog_started():
	dialogicActive = true
	
func dialog_ended():
	dialogicActive = false

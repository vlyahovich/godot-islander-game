extends Node2D

export(int) var radius = 10
export(String) var dialog_timeline = ""

var crosshair_active = false
var player_area = null
var active = true setget set_active
var interacted_area = null
var dialog = null
var dialog_output = []

signal interacted(area)
signal interacted_dialog(area, output)

func set_active(value):
	active = value
	
	if active:
		$Area2D/CollisionShape2D.set_deferred("disabled", false)
	else:
		$Area2D/CollisionShape2D.set_deferred("disabled", true)
		
func _notify_interacted(area):
	if $CooldownTimer.is_stopped() and !Globals.dialogicActive:
		interacted_area = area

		$CooldownTimer.start()

		if dialog_timeline:
			dialog = Dialogic.start(dialog_timeline)

			Globals.dialog_started()

			dialog.connect("dialogic_signal", self, "_dialogic_signal")
			dialog.connect("timeline_end", self, "_dialogic_timeline_end")

			add_child(dialog)
		else:
			emit_signal("interacted", interacted_area)

func _dialogic_timeline_end(_timeline_name):
	emit_signal("interacted_dialog", interacted_area, dialog_output)

	Globals.dialog_ended()

	dialog = null
	dialog_output = []

func _dialogic_signal(arg):
	dialog_output.append(arg)

func _on_Area2D_area_entered(area):
	var groups = area.get_groups()

	if "Crosshair" in groups:
		if player_area:
			_notify_interacted(player_area)

		crosshair_active = true
	
	if "Player" in groups:
		if crosshair_active:
			_notify_interacted(area)

			crosshair_active = false
		
		player_area = area

func _on_Area2D_area_exited(area):
	var groups = area.get_groups()
	
	if "Crosshair" in groups:
		crosshair_active = false
	
	if "Player" in groups:
		player_area = null

extends Node2D
class_name Crosshair

const crosshair_width = 30.0
const crosshair_height = 30.0

var interaction_area = null
var default_watcher_size = Vector2.ZERO

signal interaction_reached(area)

func _ready():
	_reset_position()
	
	default_watcher_size = Vector2(
		$Container/PlayerWatcher/CollisionShape2D.shape.radius,
		$Container/PlayerWatcher/CollisionShape2D.shape.height
	)
	
func _input(_event):
	if Input.is_action_just_pressed("ui_click_left"):
		queue_show(get_global_mouse_position())

func queue_show(position):
	$VisibilityTimer.start()

	global_position = position

	# visibility trick needed to avoid jumping while changing shape
	$Container.modulate = Color(1, 1, 1, 0)

	$Container/Interaction/CollisionShape2D.disabled = true
	$Container/Interaction/CollisionShape2D.disabled = false
	
	$Container/PlayerWatcher/CollisionShape2D.disabled = true
	$Container/PlayerWatcher/CollisionShape2D.disabled = false

	$AnimationPlayer.play("animate")
	
	$Container/TopL.position = Vector2.ZERO
	$Container/TopR.position = Vector2.ZERO
	$Container/BottomL.position = Vector2.ZERO
	$Container/BottomR.position = Vector2.ZERO

func queue_hide():
	$DebounceHideTimer.start()

func _reset_position():
	global_position = Vector2(-10000, -10000)

	$Container/Interaction/CollisionShape2D.disabled = true

func _on_Interaction_area_entered(area):
	var groups = area.get_groups()
	
	if "Player" in groups:
		return

	var collision_area = area.find_node("CollisionShape2D")
	var collsion_shape = collision_area.shape
	var multi = 1 / scale.x

	if collsion_shape is CapsuleShape2D:
		var height = collsion_shape.height
		var radius = collsion_shape.radius

		$Container/TopL.position = Vector2(
			-radius * multi + crosshair_width / 2,
			-height * multi + crosshair_height / 2
		)
		$Container/TopR.position = Vector2(
			radius * multi - crosshair_width / 2 - 1,
			-height * multi + crosshair_height / 2
		)
		$Container/BottomL.position = Vector2(
			-radius * multi + crosshair_width / 2,
			height * multi - crosshair_height / 2
		)
		$Container/BottomR.position = Vector2(
			radius * multi - crosshair_width / 2 - 1,
			height * multi - crosshair_height / 2
		)

		interaction_area = area

		$Container/PlayerWatcher/CollisionShape2D.shape.height = height * 1 / scale.y
		$Container/PlayerWatcher/CollisionShape2D.shape.radius = radius * 1 / scale.x

	global_position = collision_area.global_position

func _on_VisibilityTimer_timeout():
	$Container.modulate = Color(1, 1, 1, 1)

func _on_DebounceHideTimer_timeout():
	$AnimationPlayer.play("hide")
	
	yield($AnimationPlayer, "animation_finished")
	
	_reset_position()

	$AnimationPlayer.play("RESET")

func _on_PlayerWatcher_area_entered(area):
	if "Player" in area.get_groups():
		if interaction_area:
			emit_signal("interaction_reached", interaction_area)

		$Container/PlayerWatcher/CollisionShape2D.shape.height = default_watcher_size.y
		$Container/PlayerWatcher/CollisionShape2D.shape.radius = default_watcher_size.x

		queue_hide()

		interaction_area = null

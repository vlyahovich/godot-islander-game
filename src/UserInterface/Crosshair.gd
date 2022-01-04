extends Node2D

const crosshair_width = 30.0
const crosshair_height = 30.0

func _ready():
	_reset_position()
	
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
		queue_hide()
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
			radius * multi - crosshair_width / 2,
			-height * multi + crosshair_height / 2
		)
		$Container/BottomL.position = Vector2(
			-radius * multi + crosshair_width / 2,
			height * multi - crosshair_height / 2
		)
		$Container/BottomR.position = Vector2(
			radius * multi - crosshair_width / 2,
			height * multi - crosshair_height / 2
		)

	global_position = collision_area.global_position

func _on_VisibilityTimer_timeout():
	$Container.modulate = Color(1, 1, 1, 1)

func _on_DebounceHideTimer_timeout():
	$AnimationPlayer.play("hide")
	
	yield($AnimationPlayer, "animation_finished")
	
	_reset_position()

	$AnimationPlayer.play("RESET")

extends Node2D

const crosshair_width = 32
const crosshair_height = 32

var active = false
var showDelayTimer = null

func _ready():
	_reset_position()

func queue_show(position):
	showDelayTimer = Timer.new()

	add_child(showDelayTimer)

	showDelayTimer.wait_time = 0.1
	showDelayTimer.start()
	
	global_position = position
	active = true
	visible = false

	$Interaction/CollisionShape2D.disabled = false
	
	yield(showDelayTimer, "timeout")

	showDelayTimer.queue_free()
	showDelayTimer = null

	visible = true

	$AnimationPlayer.play("animate")
	
	$TopL.position = Vector2.ZERO
	$TopR.position = Vector2.ZERO
	$BottomL.position = Vector2.ZERO
	$BottomR.position = Vector2.ZERO

func queue_hide():
	if active:
		active = false

		$AnimationPlayer.play("hide")
		
		yield($AnimationPlayer, "animation_finished")
		
func _reset_position():
	global_position = Vector2(-10000, -10000)

	$Interaction/CollisionShape2D.disabled = true

	active = false
	
func _on_hide_animation_finished():
	_reset_position()

	$AnimationPlayer.play("RESET")

func _on_Interaction_area_entered(area):
	if showDelayTimer:
		visible = true

		showDelayTimer.queue_free()
		showDelayTimer = null

		$AnimationPlayer.play("animate")

	var collision_area = area.find_node("CollisionShape2D")
	var collsion_shape = collision_area.shape
	var multi = 1 / scale.x

	if collsion_shape is CapsuleShape2D:
		var height = collsion_shape.height
		var radius = collsion_shape.radius

		$TopL.position = Vector2(-radius * multi, -height * multi)
		$TopR.position = Vector2(radius * multi - crosshair_width, -height * multi)
		$BottomL.position = Vector2(-radius * multi, height * multi - crosshair_height)
		$BottomR.position = Vector2(radius * multi - crosshair_width, height * multi - crosshair_height)

	global_position = collision_area.global_position

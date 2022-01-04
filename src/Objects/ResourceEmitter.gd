extends Node2D

var target = null
var resources = []
var sprite_acceleration = 8

func _ready():
	$Resource.visible = false
	
func set_target(actor):
	target = actor
	
func _physics_process(delta):
	if !target:
		return

	var distance = 200 * delta
	
	for res in resources:
		var sprite = res.get_node("Sprite")
		var target_position = target.global_position

		sprite.global_position = lerp(sprite.global_position, target_position, sprite_acceleration * delta)

		if (sprite.global_position - target_position).length() < distance:
			resources.erase(res)
			res.queue_free()

func emit_count(origin, count):
	for _i in range(count):
		_emit_once(origin)
	
func _emit_once(origin):
	if !target:
		return

	var new_resource = $Resource.duplicate()
	var animationPlayer = new_resource.get_node("AnimationPlayer")
	var randomizeVector = Vector2(rand_range(-10, 10), rand_range(-10, 10))

	new_resource.visible = true
	new_resource.global_position = origin.global_position + randomizeVector

	add_child(new_resource)

	animationPlayer.playback_speed = rand_range(0.6, 1)
	
	if target.dir.x < 0:
		animationPlayer.play("bounce_left")
	else:
		animationPlayer.play("bounce_right")
	
	yield(animationPlayer, "animation_finished")
	
	resources.append(new_resource)

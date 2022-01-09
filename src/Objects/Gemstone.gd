extends Node2D

const gem_size = 3

func _ready():
	$CanvasLayer/AnimationPlayer.play("time")

func _physics_process(delta):
	var material = $CanvasLayer/ColorRect.material as ShaderMaterial;
	var transform = get_global_transform_with_canvas();
	var viewport_size = $CanvasLayer/ColorRect.rect_size;
	var center = ((transform.origin - Vector2(0, 3)) / viewport_size);

	material.set_shader_param("center", Vector2(center.x, 1 - center.y))

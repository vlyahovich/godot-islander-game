extends Node2D

func _ready():
	$CanvasLayer/AnimationPlayer.play("time")

func _physics_process(delta):
	var material = $CanvasLayer/ColorRect.material as ShaderMaterial;
	var transform = get_global_transform_with_canvas();
	var viewport_size = $CanvasLayer/ColorRect.rect_size;
	var center = transform.origin / viewport_size;

	material.set_shader_param("center", Vector2(center.x, 1 - center.y))

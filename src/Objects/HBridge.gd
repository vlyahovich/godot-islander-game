extends StaticBody2D

const WORLD_BIT = 0
const BRIDGES_BIT = 7

func _on_Area2D_body_entered(body):
	if "Player" in body.get_groups() or "Enemy" in body.get_groups():
		body.set_collision_mask_bit(BRIDGES_BIT, true)
		body.set_collision_mask_bit(WORLD_BIT, false)


func _on_Area2D_body_exited(body):
	if "Player" in body.get_groups() or "Enemy" in body.get_groups():
		body.set_collision_mask_bit(BRIDGES_BIT, false)
		body.set_collision_mask_bit(WORLD_BIT, true)
